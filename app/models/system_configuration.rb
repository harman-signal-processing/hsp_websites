class SystemConfiguration < ActiveRecord::Base
	belongs_to :system
	belongs_to :user
	has_many :system_configuration_options, inverse_of: :system_configuration
  has_many :system_configuration_components, inverse_of: :system_configuration

	validates :system, presence: true

	accepts_nested_attributes_for :system_configuration_options, reject_if: :all_blank
  accepts_nested_attributes_for :system_configuration_components, reject_if: :all_blank # or quantity == 0
end
