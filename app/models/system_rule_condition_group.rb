# SystemRuleConditionGroup is just what it says, really. One or more conditions grouped
# together so that they can be organized by either AND or OR.
#
class SystemRuleConditionGroup < ActiveRecord::Base
	enum logic_types: ["AND", "OR"]
	belongs_to :system_rule
	has_many :system_rule_conditions

	validates :logic_type, presence: true
	validates :system_rule, presence: true

	after_initialize :set_default_logic_type

	accepts_nested_attributes_for :system_rule_conditions, reject_if: :all_blank

	def set_default_logic_type
		self.logic_type ||= "AND"
	end

end
