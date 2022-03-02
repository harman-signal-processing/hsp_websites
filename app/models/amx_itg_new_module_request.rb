class AmxItgNewModuleRequest < ApplicationRecord
  DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/#{Rails.configuration.aws[:bucket]}\.s3\.amazonaws\.com\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze
  
	validates :device_type, :manufacturer, :models, :project_type, :num_systems, :num_devices_using_module, :expected_installation_date, :requestor, :region, :company, :email, :agree_to_validate_onsite, :agree_device_has_api_feeback, :agree_to_recieve_emails, presence: true
	validate :must_have_a_control_method
	validate :must_have_amx_controller_type

  has_attached_file :attachment
  do_not_validate_attachment_file_type :attachment
	
  before_save :set_upload_attributes
  after_save :queue_processing	
	
	def self.available_control_methods
		["RS-232 -422, -485", "IP"]
	end
	
  def must_have_a_control_method
    errors.add(:method_of_control, 'You must select at least one method of control') if method_of_control.nil?
  end  #  def must_have_a_control_method
  
  def self.available_amx_controller_types
    ["NI Series", "NX Series", "DGX Series", "DVX Series", "Other"]
  end

  def must_have_amx_controller_type
    errors.add(:amx_controller_types, 'You must select at least one amx controller type') if amx_controller_types.nil?
  end  #  def must_have_project_type

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

    path_interpolation = ":class/:attachment/:id_:timestamp/:basename.:extension"
    paperclip_file_path = Paperclip::Interpolations.interpolate(path_interpolation, attachment, '')
    
    options = { acl: 'public-read', cache_control: "max-age=7776000" }
    bucket.object(paperclip_file_path).copy_from(uploaded_object, options) # does not use paperclip, just copies the item from the upload bucket to the appropriate final destination bucket for the element

    self.processed = true
    save

    uploaded_object.delete
  end  #  def transfer_and_cleanup
  
  def is_image?
    !!(attachment_file_name.to_s.match(/(png|jpg|jpeg|tif|tiff|bmp|gif)$/i))
  end  
  
  # Store an unescaped version of the escaped URL that Amazon returns from direct upload.
  def direct_upload_url=(escaped_url)
    write_attribute(:direct_upload_url, (CGI.unescape(escaped_url) rescue nil))
  end  
  
  def attachment_download_url
    attachment.url.gsub("_original.",".")
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

      self.attachment_file_name = direct_upload_url_data[:filename]
      self.attachment_file_size = direct_upload_object.content_length
      self.attachment_content_type = direct_upload_object.content_type
      self.attachment_updated_at = direct_upload_object.last_modified
    end  #  if !self.direct_upload_url.blank? && self.direct_upload_url_changed?
  rescue Aws::S3::Errors::NoSuchKey
    tries -= 1
    if tries > 0
      sleep(3)
      retry
    else
      false
    end
  end  #  def set_upload_attributes
  
  # Queue file processing
  def queue_processing
    AmxItgNewModuleRequest.delay.transfer_and_cleanup(id) if !self.direct_upload_url.blank? && self.saved_change_to_attribute?(:direct_upload_url)
  end  
  
end  #  class AmxItgNewModuleRequest < ApplicationRecord
