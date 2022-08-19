class SystemComponent < ApplicationRecord
	include ActionView::Helpers::JavaScriptHelper

	has_many :system_configuration_components, inverse_of: :system_component
	has_many :system_rule_actions
	belongs_to :system
	belongs_to :product, optional: true

	validates :name, presence: true

end
