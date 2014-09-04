# SystemRuleConditionGroup is just what it says, really. One or more conditions grouped
# together so that they can be organized by either AND or OR.
#
class SystemRuleConditionGroup < ActiveRecord::Base
	enum logic_types: ["AND", "OR"]
	belongs_to :system_rule
	has_many :system_rule_conditions, inverse_of: :system_rule_condition_group

	validates :logic_type, presence: true
	validates :system_rule, presence: true
	validate :at_least_one_condition

	after_initialize :set_default_logic_type

	accepts_nested_attributes_for :system_rule_conditions, reject_if: proc { |src| src['system_option_id'].blank? && src['operator'].blank? }

	def set_default_logic_type
		self.logic_type ||= "AND"
	end

	def to_s
		logic = self.system_rule.system_rule_condition_groups.first == self ? '' : "#{self.logic_type} "
		"#{logic}(#{system_rule_conditions.map{|src| src.to_s}.join(' ')})"
	end

	private

	def at_least_one_condition
		if !(system_rule_conditions.length > 0)
			errors.add(:base, "Must include at least one valid condition.")
		end
	end

end
