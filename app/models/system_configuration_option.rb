class SystemConfigurationOption < ActiveRecord::Base
	belongs_to :system_configuration
	belongs_to :system_option
  has_many :system_configuration_option_values, inverse_of: :system_configuration_option
  has_many :system_option_values, through: :system_configuration_option_values

	validates :system_configuration, presence: true
	validates :system_option, presence: true

  accepts_nested_attributes_for :system_configuration_option_values, reject_if: :all_blank

  def show?
    system_option_values.length > 0 || direct_value.present?
  end

  def recipients
    @recipients ||= system_configuration_option_values.map{|scov| scov.recipients}
  end

end
