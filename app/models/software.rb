class Software < ApplicationRecord
  DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/#{Rails.configuration.aws[:bucket]}\.s3\.amazonaws\.com\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze

  extend FriendlyId
  friendly_id :formatted_name

  attr_accessor :replaces_id
  has_many :product_softwares, -> { order("product_position") }, dependent: :destroy, inverse_of: :software
  has_many :products, through: :product_softwares
  has_many :software_attachments
  has_many :software_training_classes, dependent: :destroy
  has_many :training_classes, through: :software_training_classes
  has_many :software_training_modules, -> { order('position') }, dependent: :destroy
  has_many :training_modules, through: :software_training_modules
  has_many :software_operating_systems, dependent: :destroy
  has_many :operating_systems, through: :software_operating_systems
  has_many :locale_softwares

  has_many :content_translations, as: :translatable, foreign_key: "content_id", foreign_type: "content_type"

  validates :name, presence: true
  has_attached_file :ware, S3_STORAGE.merge({
    s3_headers: lambda { |attachment|
      { "Content-Disposition" => %(attachment; filename="#{attachment.ware_file_name}") }
    },
    path: ":class/:attachment/:id_:timestamp/:basename.:extension"
  })
  do_not_validate_attachment_file_type :ware

  # process_in_background :ware # replaced with direct to s3 upload

  accepts_nested_attributes_for :products, reject_if: proc { |p| p['id'].blank? }

  before_save :set_upload_attributes
  after_save :queue_processing

  before_destroy :revert_version
  before_update  :revert_version_if_deactivated
  after_initialize :copy_attributes_from_previous_version
  after_initialize :set_default_counter
  after_save :replace_old_version, :touch_products

  belongs_to :brand, touch: true

  scope :not_associated_with_this_product, -> (product, website) {
    website.brand.softwares.where.not(id: product.softwares.select(:id))
  }

  def should_generate_new_friendly_id?
    true
  end

  def set_default_counter
    self.download_count ||= 0
  end

  def increment_count
    set_default_counter
    new_count = self.download_count + 1
    Software.where(id: self.id).update_all(download_count: new_count)
  end

  # Store an unescaped version of the escaped URL that Amazon returns from direct upload.
  def direct_upload_url=(escaped_url)
    write_attribute(:direct_upload_url, (CGI.unescape(escaped_url) rescue nil))
  end

  # Revert to previous version (if any) when deleting/inactivating software
  def revert_version
    if previous_versions.length > 0
      new_version = previous_versions.first
      previous_versions.update_all(current_version_id: new_version.id)
      new_version.update(current_version_id: nil, active: true)
    end
  end

  def revert_version_if_deactivated
    revert_version if active_was && !active
  end

  def previous_versions
    self.class.where(current_version_id: self.id).order("created_at DESC")
  end

  def replaced_by
    if self.current_version_id.present? && self.current_version_id != self.id
      self.class.find(self.current_version_id)
    end
  end

  def replace_old_version
    if self.replaces_id.present? && self.replaces_id.to_i > 0
      self.class.where(current_version_id: self.replaces_id).update_all(current_version_id: self.id, active: false)
      self.class.where(id: self.replaces_id).update_all(current_version_id: self.id, active: false)
      ProductSoftware.where(software_id: self.replaces_id).find_each do |ps|
        ProductSoftware.where(software_id: self.id, product_id: ps.product_id).first_or_create
      end
    end
  end

  def touch_products
    products.each {|p| p.touch}
  end

  def formatted_name
    f = self.name
    f += " v#{self.version}" unless self.version.blank?
    f += " (#{self.platform})" unless self.platform.blank?
    f
  end

  # Alias for search results link_name
  def link_name
    self.formatted_name
  end

  def link_name_method
    :name
  end

  # Alias for search results content_preview
  def content_preview
    self.send(content_preview_method)
  end

  def content_preview_method
    :description
  end

  def has_additional_info?
    !!(self.description.present? || self.training_modules.size > 0 || self.software_attachments.size > 0 || self.training_classes.size > 0)
  end

  def current_products
    @current_products ||= self.products & brand.current_products
  end

  # Collection of all the locales where this Software should appear.
  # By definition, it should include ALL locales unless there is one or more
  # limitation specified.
  def locales(website)
    @locales ||= (locale_softwares.size > 0) ? locale_softwares.pluck(:locale) : website.list_of_all_locales
  end

  # Final upload processing step
  def self.transfer_and_cleanup(id)
    software = find(id)
    direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(software.direct_upload_url)
    s3 = Aws::S3::Resource.new

    path_interpolation = ":class/:attachment/:id_:timestamp/:basename.:extension"
    paperclip_file_path = Paperclip::Interpolations.interpolate(path_interpolation, software.ware, 'original')

    # paperclip_file_path = "documents/uploads/#{id}/original/#{direct_upload_url_data[:filename]}"
    bucket = s3.bucket(Rails.configuration.aws[:bucket])
    uploaded_object = bucket.object(direct_upload_url_data[:path])
    options = { acl: 'public-read' }
    # 7zip files cause problems for Windows users unless we explicitely set the following:
    if direct_upload_url_data[:filename].to_s.match(/\.7z$|\.mu3$/i)
      options[:metadata_directive] = "REPLACE"
      options[:content_type] = "binary/octet-stream"
      options[:content_disposition] = "attachment"
    end
    bucket.object(paperclip_file_path).copy_from(uploaded_object, options)

    software.processed = true
    software.save

    uploaded_object.delete
  end

  # Allows this item to be treated as a Site Element for sorting
  def resource_type
    self.category == "firmware" ? "Firmware" : "Software"
  end

  def copy_attributes_from_previous_version
    if self.replaces_id.present?
      old_software = self.class.find(self.replaces_id)
      self.name ||= old_software.name
      self.brand_id ||= old_software.brand_id
      self.platform ||= old_software.platform
      self.bit ||= old_software.bit
      self.category ||= old_software.category
      self.layout_class ||= old_software.layout_class
      self.side_content ||= old_software.side_content
      self.description ||= old_software.description
      if self.products.length == 0
        self.products = old_software.products
      end
      begin
        self.version ||= old_software.version.next
      rescue
        # oh well, auto next version didn't work
      end
    end
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

      self.ware_file_name = direct_upload_url_data[:filename]
      self.ware_file_size = direct_upload_object.content_length
      self.ware_content_type = direct_upload_object.content_type
      self.ware_updated_at = direct_upload_object.last_modified
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
    Software.delay.transfer_and_cleanup(id) if !self.direct_upload_url.blank? && self.saved_change_to_attribute?(:direct_upload_url)
  end

end
