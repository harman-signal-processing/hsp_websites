class ProductDocument < ApplicationRecord
  extend FriendlyId
  friendly_id :document_file_name

  belongs_to :product, touch: true
  has_attached_file :document

  acts_as_list scope: :product_id

  validates :product_id, presence: true
  validates_attachment :document, presence: true
  do_not_validate_attachment_file_type :document

  #process_in_background :document
  before_save :set_upload_attributes
  after_save :queue_processing

  # For cleaning up the product pages, no need to re-state the product name in
  # the link.
  def name(options={})
    if self.name_override.present?
      self.name_override
    elsif self.document_type.blank? || self.document_type.match(/other/i)
      self.document_file_name
    else
      doctype = I18n.t("document_type.#{self.document_type}")
      ret = (options[:hide_product_name]) ? doctype : "#{self.product.name} #{doctype}"
      unless self.language.blank? || !!(self.document_type.match(/^cad/))
        lang = I18n.t("language.#{self.language}")
        ret += "-#{lang}"
      end
      ret
    end
  end

  # Store an unescaped version of the escaped URL that Amazon returns from direct upload.
  def direct_upload_url=(escaped_url)
    write_attribute(:direct_upload_url, (CGI.unescape(escaped_url) rescue nil))
  end

  # Final upload processing step
  def self.transfer_and_cleanup(id)
    product_document = find(id)
    product_document.transfer_and_cleanup if product_document.direct_upload_url.present?
  end

  def transfer_and_cleanup
    direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(direct_upload_url)
    s3 = Aws::S3::Resource.new

    path_interpolation = S3_STORAGE[:path]
    paperclip_file_path = Paperclip::Interpolations.interpolate(path_interpolation, document, 'original')

    bucket = s3.bucket(Rails.configuration.aws[:bucket])
    uploaded_object = bucket.object(direct_upload_url_data[:path])
    options = { acl: 'public-read' }
    bucket.object(paperclip_file_path).copy_from(uploaded_object, options)

    self.processed = true
    save

    uploaded_object.delete
  end

protected

  # Set attachment attributes from the direct upload
  # @note Retry logic handles S3 "eventual consistency" lag.
  def set_upload_attributes
    tries ||= 5
    if !self.direct_upload_url.blank? && self.direct_upload_url_changed?
      direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(direct_upload_url)
      s3 = Aws::S3::Resource.new
      direct_upload_object = s3.bucket(Rails.configuration.aws[:bucket]).object(direct_upload_url_data[:path])

      self.document_file_name = direct_upload_url_data[:filename]
      self.document_file_size = direct_upload_object.content_length
      self.document_content_type = direct_upload_object.content_type
      self.document_updated_at = direct_upload_object.last_modified
    end
  rescue Aws::S3::Errors::NoSuchKey
    tries -= 1
    if tries > 0
      sleep(3)
      retry
    else
      false
    end
  end

  # Queue file processing
  def queue_processing
    ProductDocument.delay.transfer_and_cleanup(id) if !self.direct_upload_url.blank? && self.saved_change_to_attribute?(:direct_upload_url)
  end

end
