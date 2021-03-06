class SystemComponent < ApplicationRecord
	include ActionView::Helpers::JavaScriptHelper

	has_many :system_configuration_components, inverse_of: :system_component
	has_many :system_rule_actions
	belongs_to :system
	belongs_to :product

	validates :name, presence: true
	validates :system, presence: true

end
