# A DownloadRegistration represents an instance where a person
# visited the site and filled out the form to get a specific file.
# The file to be downloaded comes from the related RegisteredDownload.
#
# Alternatively, the RegisteredDownload could be configured to simply
# send a unique coupon code which can redeemed elsewhere. If so,
# the email instructions should include a link to the store where
# the coupon is to be redeemed.
#
require 'digest/sha1'
class DownloadRegistration < ActiveRecord::Base
  belongs_to :registered_download

  validates :first_name, :registered_download_id, presence: true

  validates :email, presence: true, email: true
    # uniqueness: {scope: :registered_download_id},

  validates :serial_number,
    presence: true,
    uniqueness: {scope: :registered_download_id},
    if: :require_serial_number?

  validates :employee_number,
    presence: true,
    uniqueness: {scope: :registered_download_id},
    if: :require_employee_number?

  validates :store_number,
    presence: true,
    if: :require_store_number?

  validates :manager_name,
    presence: true,
    if: :require_manager_name?

  validate :download_code_is_valid,
    on: :create

  attr_accessor :code_you_received
  before_create :create_download_code
  after_create :deliver_download_code, :deliver_admin_notice

  has_attached_file :receipt, S3_STORAGE.merge({
    bucket: Rails.configuration.aws[:protected_bucket],
    s3_host_alias: nil,
    path: ":class/:attachment/:id_:timestamp/:basename.:extension"
  })

  do_not_validate_attachment_file_type :receipt
  validates :receipt, presence: true, if: :require_receipt?


  # Does the related RegisteredDownload require the receipt?
  #
  def require_receipt?
    !!(self.registered_download.require_receipt?)
  end

  # Does the related RegisteredDownload require a serial number?
  #
  def require_serial_number?
    !!(self.registered_download.require_serial_number?)
  end

  # Does the related RegisteredDownload require an employee number?
  #
  def require_employee_number?
    !!(self.registered_download.require_employee_number?)
  end

  # Does the related RegisteredDownload require a store number?
  #
  def require_store_number?
    !!(self.registered_download.require_store_number?)
  end

  # Does the related RegisteredDownload require a manager's name?
  #
  def require_manager_name?
    !!(self.registered_download.require_manager_name?)
  end

  # When the user returns to download a file, this checks to see
  # if the provided code matches the one we generated earlier.
  #
  def download_code_is_valid
    rd = RegisteredDownload.find(self.registered_download_id)
    unless rd.valid_code.blank? || (rd.valid_code == code_you_received) || (rd.valid_code.gsub(/\-/, "") == code_you_received.gsub(/\-/, ""))
      errors.add(:code_you_received, "does not appear to be valid.")
    end
  end

  # Hashes a bunch of stuff together to create a unique code.
  # Or, if the related RegisteredDownload sends a coupon code, then
  # we choose the next code and remove it from the list.
  #
  def create_download_code
    if self.registered_download.send_coupon_code?
      self.download_code = self.registered_download.available_coupon_codes.first
      self.registered_download.remove_coupon_code!(self.download_code)
    else
      salt = (0..2).map{65.+(rand(25)).chr}.join
      self.download_code = Digest::SHA1.hexdigest("#{salt}#{self.email}#{self.serial_number}#{self.registered_download.valid_code}")
    end
  end

  # Sends the download code or the coupon code depending on the
  # related RegisteredDownload
  #
  def deliver_download_code
    if self.registered_download.send_coupon_code? || !self.registered_download.protected_software_file_name.blank?
      RegisteredDownloadsMailer.download_link(self).deliver
    end
  end

  # If configured, sends a notice to the admin when a new registration
  # is created.
  #
  def deliver_admin_notice
    unless self.registered_download.cc.blank?
      RegisteredDownloadsMailer.admin_notice(self).deliver
    end
  end

  # This _could_ come from the route "registered_download", but
  # the mailer needs to know the host anyway--which we'll pull from
  # the associated RegisteredDownload -> Website
  #
  def download_link
    "http://#{self.registered_download.brand.default_website.url}/#{self.registered_download.url}/get_it/#{self.download_code}"
  end

end
