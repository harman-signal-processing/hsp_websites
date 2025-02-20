require 'addressable'
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
    }, processors: [:thumbnail, :compression] }
  do_not_validate_attachment_file_type :resource
  process_in_background :resource

  has_attached_file :executable
  do_not_validate_attachment_file_type :executable

  attr_accessor :replaces_element
  attr_accessor :versions_to_delete

  validates :name, presence: true
  validates :resource_type, presence: true, if: :show_on_public_site?
  has_many :product_site_elements, dependent: :destroy, inverse_of: :site_element
  has_many :products, through: :product_site_elements
  has_many :site_element_attachments, dependent: :destroy # added for martin
  belongs_to :access_level, optional: true
  has_many :manufacturer_partners
  has_many :programmer_site_elements, dependent: :destroy, foreign_key: "site_element_id", class_name: "Vip::ProgrammerSiteElement"
  has_many :programmers, through: :programmer_site_elements, class_name: "Vip::Programmer"

  accepts_nested_attributes_for :products, reject_if: proc { |p| p['id'].blank? }

  after_initialize :copy_attributes_from_previous_version
  before_save :set_upload_attributes
  after_save :queue_processing, :replace_old_version, :touch_products
  before_update :reset_link_check

  scope :to_be_checked, -> (options={}) {
    limit = options[:limit] || 500
    where("link_checked_at < ? OR link_checked_at IS NULL", 30.days.ago).
      where("resource_file_name IS NOT NULL OR executable_file_name IS NOT NULL").
      order("link_checked_at ASC").
      limit(limit)
  }

  def self.resource_types(options={})
    defaults = ["Image"]
    begin
      db_resource_types = (options.length > 0) ?
        where(options).pluck(:resource_type) :
        pluck(:resource_type)
      (db_resource_types.uniq + defaults).uniq.sort{|a,b| a.downcase <=> b.downcase}
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

  def has_other_versions?
    other_versions.length > 0
  end

  def other_versions
    @other_versions ||= all_versions.where.not(id: self.id)
  end

  def all_versions
    @all_versions ||= self.class.where(current_version_id: self.current_version_id).order(:version, :created_at)
  end

  def latest_version
    all_versions.last
  end

  def is_latest_version?
    self == latest_version
  end

  def copy_attributes_from_previous_version
    if self.replaces_element.present?
      old_element = self.class.find(self.replaces_element)
      self.name = old_element.name
      self.language = old_element.language
      self.resource_type = old_element.resource_type
      self.brand_id = old_element.brand_id
      self.access_level = old_element.access_level
      self.show_on_public_site = old_element.show_on_public_site
      self.is_document = old_element.is_document
      self.is_software = old_element.is_software
      self.products = old_element.products
      begin
        old_element.version ||= "A"
        self.version = old_element.version.next
      rescue
        # oh well, auto next version didn't work
      end
    end
  end

  # Need to ensure all records have the "current_version_id" present--even if
  # itself is the only version of this site element.
  # But, we can't really make it a required field because it gets filled in
  # later and always by the application--not the user.
  def replace_old_version
    if self.replaces_element.present? && self.replaces_element.to_i > 0
      self.class.where(current_version_id: self.replaces_element).update_all(current_version_id: self.id)
      self.class.where(id: self.replaces_element).update_all(current_version_id: self.id)
    else
      self.update_columns(current_version_id: self.id)
    end
  end

  def touch_products
    products.each{|p| p.touch}
  end

  def current_products
    products.where(product_status_id: ProductStatus.current_ids)
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
      resource_file_name[/\.(\w*)$/, 1].to_s.downcase
    elsif executable_file_name.present?
      executable_file_name[/\.(\w*)$/, 1].to_s.downcase
    elsif content.present?
      'html'
    end
  end

  def url
    if external_url.present? | resource_file_name.present? | executable_file_name.present?
      "/#{I18n.locale.to_s}/site_elements/#{self.to_param}"
    elsif content.present?
      "/resource/#{self.to_param}.html"
    end
  end

  def direct_url
    case attachment_type
    when 'external'
      external_url
    when 'resource'
      resource.url
    when 'executable'
      executable.url
    when 'html'
      url
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
    elsif content.present?
      'html'
    end
  end

  # Long name includes version and language if present
  def long_name
    n = name
    n += " (" if version.present? || language.present?
    n += "rev#{ version }" if version.present?
    n += "-" if version.present? && language.present?
    n += "#{ language.upcase }" if language.present?
    n += ")" if version.present? || language.present?
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

    options = { acl: 'public-read', cache_control: "max-age=7776000" }
    # 7zip files cause problems for Windows users unless we explicitely set the following:
    if direct_upload_url_data[:filename].to_s.match(/\.7z$|\.mu3|\.dwg|\.3ds$/i)
      options[:metadata_directive] = "REPLACE"
      options[:content_type] = "binary/octet-stream"
      options[:content_disposition] = "attachment"
    end

    if self.is_image?
      update( resource: URI.parse(Addressable::URI.parse(direct_upload_url).normalize) )
    else
      bucket.object(paperclip_file_path).copy_from(uploaded_object, options)
    end

    uploaded_object.delete
  end

  # This file is related to one or more products, but all of those products are discontinued
  def discontinued?
    @discontinued ||= (products.length > 0 && products.where(product_status: ProductStatus.current_ids).size == 0)
  end

  # Refactored from the Website model, this collects and caches all the SiteElements that
  # are relevant to the given Website and accessible by the given User.
  def self.downloads(website, user)
    Rails.cache.fetch("#{website.cache_key_with_version}/#{user}/#{I18n.locale}/se_downloads", expires_in: 6.hours) do
      downloads = {}
      ability = Ability.new(user)
      website.site_elements.where(show_on_public_site: true, link_status: ["", nil, "200"]).where("resource_type IS NOT NULL AND resource_type != ''").find_each do |site_element|
        if ability.can?(:read, site_element) && site_element.current_products.size > 0
          downloads = downloads.deep_merge( { site_element.hash_key => site_element.details_hash } )
        end
      end
      downloads
    end
  end

  # Collects and caches hash data for the current SiteElement. Caching here helps speed up
  # caching the same data for multiple users with different access when both users can access
  # this SiteElement.
  def details_hash
    Rails.cache.fetch("#{cache_key_with_version}/#{I18n.locale}/details_hash", expires_in: 6.days) do
      {
        param_name: hash_key,
        name: doctype_name,
        downloads: [download_details_hash]
      }
    end
  end

  # Determines the key to be used in the big hash of all the downloads
  def hash_key
    name = I18n.t("resource_type.#{resource_type_key}", default: resource_type)
    key = name.to_s.singularize.downcase.gsub(/[^a-z0-9]/, '')
    key += "-discontinued" if key == "cutsheet" && discontinued?
    key.parameterize
  end

  def reset_link_check
    if resource_updated_at_changed? || executable_updated_at_changed?
      self.link_checked_at = Time.now
      self.link_status = "200"
    end
  end

  def bad_link?
    (self.link_status.present? && self.link_status != "200")
  end

protected

  # Determines the doctype_name to be associated with this item in the big hash of all downloads
  def doctype_name
    name = I18n.t("resource_type.#{resource_type_key}", default: resource_type)
    doctype_name = I18n.locale.match(/zh/i) ? name : name.to_s.pluralize
    if hash_key.match?(/cutsheet/)
      doctype_name += discontinued? ? " (Discontinued)" : " (Current)"
    end
    doctype_name
  end

  # Just a simple collection of attributes to be used the big hash of all downloads
  def download_details_hash
    {
      name: long_name,
      file_name: file_name,
      thumbnail: is_image? ? resource.url(:tiny_square) : nil,
      url: url,
      resource_type: resource_type_key
    }
  end

  # Determines the file name to be used in this item's download_details_hash
  def file_name
    case attachment_type
    when 'resource'
      resource_file_name
    when 'executable'
      executable_file_name
    else
      url
    end
  end

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
    transfer_and_cleanup if !self.direct_upload_url.blank? && self.saved_change_to_attribute?(:direct_upload_url)
  end

end
