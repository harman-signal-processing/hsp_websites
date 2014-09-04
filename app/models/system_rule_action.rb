# SystemRuleAction is something triggered by one or more SystemRuleCondition as part
# of a System configuration. The action can be either show/hide an option/value or
# show an alert.
#
class SystemRuleAction < ActiveRecord::Base
	enum action_types: [:show, :hide, :alert]
	belongs_to :system_rule
	
	# Will have at least one of: option, value, alert (text)
	belongs_to :system_option
	belongs_to :system_option_value
	# validates :alert, presence: true # only if neither option nor value ids present

	validates :action_type, presence: true
	validates :system_rule, presence: true

	def to_s
		case action_type
		when 'alert'
			"show alert: '#{self.alert.truncate(30).html_safe }'"
		else
			"#{action_type} #{system_option.name}"
		end
	end
end
