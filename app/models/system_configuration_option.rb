class SystemConfigurationOption < ActiveRecord::Base
	belongs_to :system_configuration
	belongs_to :system_option
	belongs_to :system_option_value

	validates :system_configuration, presence: true
	validates :system_option, presence: true
end
