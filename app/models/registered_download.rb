# A RegisteredDownload represents a file that can be downloaded
# only if the customer registered to get it. Usually this comes from
# a mailed card with a "valid_code" on the card. People who register
# to download the file are instances of DownloadRegistration.
#
class RegisteredDownload < ActiveRecord::Base
  has_many :download_registrations
  belongs_to :brand
  validates :name, :brand, :from_email, :subject, presence: true
  validates :per_download_limit, numericality: {greater_than: 0}

  has_attached_file :protected_software, S3_STORAGE.merge({
    bucket: Rails.configuration.aws[:protected_bucket],
    s3_host_alias: nil,
    path: ":class/:attachment/:id_:timestamp/:basename.:extension"
  })

  do_not_validate_attachment_file_type :protected_software

  after_initialize :setup_defaults
  after_save :save_templates_to_filesystem

  # Setup some default values
  #
  def setup_defaults
    self.per_download_limit ||= 5
    self.html_template ||= "<html><head><title>Software Download</title></head><body>~~content~~</body></html>"
    self.intro_page_content ||= "Complete the form below to download this super de-duper file."
    self.confirmation_page_content ||= "Thanks for registering! Watch your email for the download link..."
    self.email_template ||= "<html><head><title>Software Download</title></head><body>~~download_link~~</body></html>"
    self.download_page_content ||= "Success! Your download should begin momentarily. If not, click the link below:"
  end

  # Sums the number of times each of the corresponding DownloadRegistration
  # has downloaded the file. (Only pertinent if this RegisteredDownload is NOT
  # configured to send coupon codes.)
  #
  def download_count
    download_registrations.inject(0){|total,r| total += r.download_count.to_i}
  end

  # If this RegisteredDownload is configured to offer a drop-down of products
  # from which the customer chooses while registering, then this method splits
  # that information into individual options. (They're stored as a simple comma-
  # separated list.)
  #
  def product_options_for_select
    self.products.split(/\,\s*/)
  end

  # Prepare the user-submitted html layout to be saved to the filesystem so
  # rails can use it as as a layout file.
  #
  def html_layout
    self.html_template.gsub(/~~content~~/, "<%= yield %>")
  end

  # Determine the filename for the corresponding HTML layout
  #
  def html_layout_filename
    Rails.root.join("public", "system", "layouts", brand.default_website.folder, "registered_download_#{self.id}.html.erb")
  end

  # Prepare the user-submitted email layout to be saved to the filesystem so
  # the rails mailer can use it. NOTE: if this RegisteredDownload is configured
  # to send a coupon code, then the ~~download_link~~ is replaced with the code.
  # Otherwise, it is replaced with a complete, unique URL.
  #
  def email_layout
    if self.send_coupon_code?
      self.email_template.gsub(/~~download_link~~/, "<%= @download_registration.download_code %>")
    else
      self.email_template.gsub(/~~download_link~~/, "<%= @download_registration.download_link %>")
    end
  end

  # Determine the filename for the corresponding email layout
  #
  def email_layout_filename
    Rails.root.join("public", "system", "mailers", brand.default_website.folder, "registered_download_notice_#{self.id}.html.erb")
  end

  def email_layout_path
    #Rails.root.join("public", "system", "mailers", brand.default_website.folder)
    "../../public/system/mailers/#{brand.default_website.folder}"
  end

  def email_template_name
    "registered_download_notice_#{self.id}"
  end

  # After creating/updating the RegisteredDownload this will check for changes
  # to the layouts (html and email) and update the corresponding files which
  # are stored on the filesystem. (Rails will only use layouts which are files.)
  #
  def save_templates_to_filesystem
    if html_template_changed? || !File.exists?(self.html_layout_filename)
      FileUtils.mkdir_p(File.dirname(self.html_layout_filename))
      File.open(self.html_layout_filename, 'w+') {|f| f.write(self.html_layout)}
    end
    if email_template_changed? || !File.exists?(self.email_layout_filename)
      FileUtils.mkdir_p(File.dirname(self.email_layout_filename))
      File.open(self.email_layout_filename, 'w+') {|f| f.write(self.email_layout)}
    end
  end

  # Splits the "coupon_codes" field into individual codes
  #
  def available_coupon_codes
    self.coupon_codes.to_s.split(/\n\r|\n|\,\s?|\;\s?|\"\s?\"/).collect{|c| c.chomp}
  end

  # Removes the given coupon_code (it has been assigned) and updates
  # the database!
  #
  def remove_coupon_code!(coupon_code)
    codes = self.available_coupon_codes
    codes.delete(coupon_code)
    self.update_attributes(coupon_codes: codes.join("\r\n"))
  end

  # Column headers for excel export
  #
  def headers_for_export
    h = ["First Name", "Last Name", "Email", "Subscribe?", "Date"]
    h << "Product" unless self.products.blank?
    h << "Product Serial Number" if self.require_serial_number?
    h << "Employee Number" if self.require_employee_number?
    h << "Store Number" if self.require_store_number?
    h << "Manager Name" if self.require_manager_name?
    if self.send_coupon_code?
      h << "Coupon Code"
    else
      h << "Downloads"
    end
    h
  end

  # Column refs for excel export
  #
  def columns_for_export
    c = [:first_name, :last_name, :email, :subscribe, :created_at]
    c << :product unless self.products.blank?
    c << :serial_number if self.require_serial_number?
    c << :employee_number if self.require_employee_number?
    c << :store_number if self.require_store_number?
    c << :manager_name if self.require_manager_name?
    if self.send_coupon_code?
      c << :download_code
    else
      c << :download_count
    end
    c
  end

  # Re-sends messages to those who have not yet downloaded the file
  # (This is probably only used when the file was not ready for download when
  # the first registrations came through)
  #
  def send_messages_to_undownloaded
    self.download_registrations.where(download_count: 0).each do |download_registration|
      download_registration.deliver_download_code
    end
  end

  # Convenience method gathers the required fields for this download.
  #
  def required_fields
    r = ["first name", "last name", "email"]
    r << "code received (postcard, etc.)" unless self.send_coupon_code? || self.valid_code.blank?
    r << "receipt (scan/photo)" if self.require_receipt?
    r << "serial number" if self.require_serial_number?
    r << "employee number" if self.require_employee_number?
    r << "store number" if self.require_store_number?
    r << "manager's name" if self.require_manager_name?
    r
  end

end
