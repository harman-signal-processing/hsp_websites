class SystemConfigurationOptionValue < ActiveRecord::Base
  belongs_to :system_configuration_option
  belongs_to :system_option_value

  validates :system_configuration_option, presence: true
  validates :system_option_value, presence: true

end
