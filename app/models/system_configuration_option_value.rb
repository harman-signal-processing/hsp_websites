class SystemConfigurationOptionValue < ApplicationRecord
  belongs_to :system_configuration_option
  belongs_to :system_option_value

  def recipients
    if system_option_value.send_mail_to.present?
      @recipients ||= system_option_value.send_mail_to.split(/\s\,/)
    end
  end

end
