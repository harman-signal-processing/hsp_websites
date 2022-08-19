class SystemConfiguration < ApplicationRecord
	belongs_to :system
	belongs_to :user, optional: true
	has_many :system_configuration_options, inverse_of: :system_configuration
  has_many :system_configuration_components, inverse_of: :system_configuration

	accepts_nested_attributes_for :system_configuration_options, reject_if: :all_blank
  accepts_nested_attributes_for :system_configuration_components, reject_if: :all_blank # or quantity == 0

  before_create :generate_access_hash

  def generate_access_hash
    self.access_hash = SecureRandom.uuid
  end

  def recipients
    @recipients = []
    if self.system.send_mail_to.present?
      @recipients << self.system.send_mail_to
    end
    @recipients += system_configuration_options.map{|sco| sco.recipients}
    if @recipients.length == 0
      @recipients << from
    end
    @recipients.flatten.compact
  end

  def from
    begin
      self.system.brand.support_email
    rescue
      "support@bssaudio.com"
    end
  end
end
