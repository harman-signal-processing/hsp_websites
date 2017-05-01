class Software < ApplicationRecord
  DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/#{Rails.configuration.aws[:bucket]}\.s3\.amazonaws\.com\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze

  extend FriendlyId
  friendly_id :formatted_name

  attr_accessor :replaces_id
  has_many :product_softwares, -> { order("product_position") }, dependent: :destroy
  has_many :products, through: :product_softwares
  has_many :software_attachments
  has_many :software_training_classes, dependent: :destroy
  has_many :training_classes, through: :software_training_classes
  has_many :software_training_modules, -> { order('position') }, dependent: :destroy
  has_many :training_modules, through: :software_training_modules
  has_many :software_operating_systems, dependent: :destroy
  has_many :operating_systems, through: :software_operating_systems

  validates :name, :brand_id, presence: true
  has_attached_file :ware, S3_STORAGE.merge({
    s3_headers: lambda { |attachment|
      { "Content-Disposition" => %(attachment; filename="#{attachment.ware_file_name}") }
    },
    path: ":class/:attachment/:id_:timestamp/:basename.:extension"
  })
  do_not_validate_attachment_file_type :ware

  # process_in_background :ware # replaced with direct to s3 upload

  before_save :set_upload_attributes
  after_save :queue_processing

  before_destroy :revert_version
  before_update  :revert_version_if_deactivated
  after_initialize :set_default_counter, :determine_platform
  after_save :replace_old_version, :touch_products

  belongs_to :brand, touch: true

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
      new_version = previous_versions.last
      previous_versions.update_all(current_version_id: new_version.id)
      new_version.update_attributes(current_version_id: nil, active: true)
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
    if self.replaces_id && self.replaces_id.to_i > 0
      self.class.where(current_version_id: self.replaces_id).update_all(current_version_id: self.id, active: false)
      self.class.where(id: self.replaces_id).update_all(current_version_id: self.id, active: false)
      ProductSoftware.where(software_id: self.replaces_id).each do |ps|
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

  # If the platform field is blank
  def determine_platform
    if platform.blank?
      (self.operating_systems.pluck(:name) + self.operating_systems.pluck(:arch)).join(" ")
    end
  end

  # Alias for search results link_name
  def link_name
    self.formatted_name
  end

  # Alias for search results content_preview
  def content_preview
    self.description
  end

  def has_additional_info?
    !!(self.description.present? || self.training_modules.count > 0 || self.software_attachments.count > 0 || self.training_classes.count > 0)
  end

  def current_products
    @current_products ||= self.products & brand.current_products
  end

  # Final upload processing step
  def self.transfer_and_cleanup(id)
    software = find(id)
    direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(software.direct_upload_url)
    s3 = AWS::S3.new

    path_interpolation = ":class/:attachment/:id_:timestamp/:basename.:extension"
    paperclip_file_path = Paperclip::Interpolations.interpolate(path_interpolation, software.ware, 'original')

    # paperclip_file_path = "documents/uploads/#{id}/original/#{direct_upload_url_data[:filename]}"
    s3.buckets[Rails.configuration.aws[:bucket]].objects[paperclip_file_path].copy_from(direct_upload_url_data[:path], acl: :public_read)

    software.processed = true
    software.save

    s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].delete
  end

protected

  # Set attachment attributes from the direct upload
  # @note Retry logic handles S3 "eventual consistency" lag.
  def set_upload_attributes
    tries ||= 5
    if !self.direct_upload_url.blank? && self.direct_upload_url_changed?
      direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(direct_upload_url)
      s3 = AWS::S3.new
      direct_upload_head = s3.buckets[Rails.configuration.aws[:bucket]].objects[direct_upload_url_data[:path]].head

      self.ware_file_name = direct_upload_url_data[:filename]
      self.ware_file_size = direct_upload_head.content_length
      self.ware_content_type = direct_upload_head.content_type
      self.ware_updated_at = direct_upload_head.last_modified
    end
  rescue AWS::S3::Errors::NoSuchKey
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
    Software.delay.transfer_and_cleanup(id) if !self.direct_upload_url.blank? && self.direct_upload_url_changed?
  end

end
