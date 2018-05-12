class SiteElement < ApplicationRecord
  DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/#{Rails.configuration.aws[:bucket]}\.s3\.amazonaws\.com\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze

  extend FriendlyId
  friendly_id :slug_candidates

  belongs_to :brand, touch: true
  has_attached_file :resource, {
    styles: { large: "550x370",
      medium: "480x360",
      small: "240x180",
      thumb: "100x100",
      tiny: "64x64",
      tiny_square: "64x64#"
    }}.merge(S3_STORAGE)
  do_not_validate_attachment_file_type :resource

  has_attached_file :executable, S3_STORAGE
  do_not_validate_attachment_file_type :executable

  validates :brand, :name, presence: true
  validates :resource_type, presence: true, if: :show_on_public_site?
  has_many :product_site_elements, dependent: :destroy, inverse_of: :site_element
  has_many :products, through: :product_site_elements
  belongs_to :access_level

  before_save :set_upload_attributes
  after_save :queue_processing

  def self.resource_types
    defaults = ["Wallpaper"]
    begin
      from_db = select("distinct(resource_type)").order("resource_type").all.collect{|r| r.resource_type}
      (from_db + defaults).uniq.sort{|a,b| a.downcase <=> b.downcase}
    rescue
      defaults
    end
  end

  def slug_candidates
    [
      :name,
      [:brand_name, :name],
      [:brand_name, :resource_type_key, :name],
    ]
  end

  def brand_name
    brand.name
  end

  def is_image?
    !!(resource_file_name.to_s.match(/(png|jpg|jpeg|tif|tiff|bmp|gif)$/i))
  end

  # Store an unescaped version of the escaped URL that Amazon returns from direct upload.
  def direct_upload_url=(escaped_url)
    write_attribute(:direct_upload_url, (CGI.unescape(escaped_url) rescue nil))
  end

  def extension
    if external_url.present?
      ''
    elsif resource_file_name.present?
      resource_file_name[/\.(\w*)$/, 1].downcase
    elsif executable_file_name.present?
      executable_file_name[/\.(\w*)$/, 1].downcase
    end
  end

  def url
    if external_url.present?
      external_url
    elsif resource_file_name.present?
      resource.url
    elsif executable_file_name.present?
      executable.url
    end
  end

  def resource_type_key
    self.resource_type.parameterize.underscore
  end

  def attachment_type
    if external_url.present?
      'external'
    elsif resource_file_name.present?
      'resource'
    elsif executable_file_name.present?
      'executable'
    end
  end

  # Long name includes version and language if present
  def long_name
    n = name
    n += " rev#{ version }" if version.present?
    n+= " #{ language }" if language.present?
    n
  end

  # Final upload processing step
  def self.transfer_and_cleanup(id)
    element = find(id)
    element.transfer_and_cleanup if element.direct_upload_url.present?
  end

  def transfer_and_cleanup
    direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(direct_upload_url)
    s3 = Aws::S3::Resource.new

    bucket = s3.bucket(Rails.configuration.aws[:bucket])
    uploaded_object = bucket.object(direct_upload_url_data[:path])

    if self.attachment_type == 'resource'
      path_interpolation = S3_STORAGE[:path]
      paperclip_file_path = Paperclip::Interpolations.interpolate(path_interpolation, resource, 'original')
    else
      path_interpolation = ":class/:attachment/:id_:timestamp/:basename_:style.:extension"
      paperclip_file_path = Paperclip::Interpolations.interpolate(path_interpolation, executable, 'original')
    end

    options = { acl: 'public-read' }
    # 7zip files cause problems for Windows users unless we explicitely set the following:
    if direct_upload_url_data[:filename].to_s.match(/\.7z$/i)
      options[:metadata_directive] = "REPLACE"
      options[:content_type] = "binary/octet-stream"
      options[:content_disposition] = "attachment"
    end
    bucket.object(paperclip_file_path).copy_from(uploaded_object, options)

    process_in_background attachment_type.to_sym

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

      if direct_upload_object.content_type.to_s.match(/image\/|pdf/i)
        self.resource_file_name = direct_upload_url_data[:filename]
        self.resource_file_size = direct_upload_object.content_length
        self.resource_content_type = direct_upload_object.content_type
        self.resource_updated_at = direct_upload_object.last_modified
      else
        self.executable_file_name = direct_upload_url_data[:filename]
        self.executable_file_size = direct_upload_object.content_length
        self.executable_content_type = direct_upload_object.content_type
        self.executable_updated_at = direct_upload_object.last_modified
      end
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
    SiteElement.delay.transfer_and_cleanup(id) if !self.direct_upload_url.blank? && self.saved_change_to_attribute?(:direct_upload_url)
  end

end
