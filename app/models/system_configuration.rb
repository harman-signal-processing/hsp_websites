class SystemConfiguration < ActiveRecord::Base
	belongs_to :system
	belongs_to :user
	has_many :system_configuration_options

	validates :system, presence: true

	accepts_nested_attributes_for :system_configuration_options, reject_if: :all_blank
end
