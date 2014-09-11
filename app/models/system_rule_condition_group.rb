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

	after_initialize :set_default_logic_type, :build_conditions

	accepts_nested_attributes_for :system_rule_conditions, 
		reject_if: proc { |src| src[:system_option_id].blank? && src[:operator].blank? },
		allow_destroy: true

	def set_default_logic_type
		self.logic_type ||= "AND"
	end

	def build_conditions
		if self.new_record?
			(3 - system_rule_conditions.length).times { system_rule_conditions.build }
		end
	end

	def to_s
		logic = self.is_first? ? '' : "#{self.logic_type} "
		"#{logic}(#{system_rule_conditions.map{|src| src.to_s}.join(' ')})"
	end

	def to_js
		logic = self.is_first? ? '' : " #{ js_logic_type} "
		"#{logic} #{ system_rule_conditions.map{|src| src.to_js}.join }"
	end

	def js_logic_type
		self.logic_type.to_s.match(/AND/i) ? '&&' : '||'
	end

	def is_first?
		self.system_rule.system_rule_condition_groups.first == self
	end

	private

	def at_least_one_condition
		if !(system_rule_conditions.length > 0)
			errors.add(:base, "Must include at least one valid condition.")
		end
	end

end
