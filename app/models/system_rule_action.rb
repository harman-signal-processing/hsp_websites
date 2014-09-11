# SystemRuleAction is something triggered by one or more SystemRuleCondition as part
# of a System configuration. The action can be either show/hide an option/value or
# show an alert.
#
class SystemRuleAction < ActiveRecord::Base
	include ActionView::Helpers::JavaScriptHelper

	# Order is important here. Read the notes for 'oppsite_action' below
	enum action_types: [:show, :hide, :enable, :disable, :alert]

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

	def to_js(options={})
		action = (options[:opposite] == true) ? opposite_action : action_type

		case action
			when 'alert'
      	"if (skip_alerts == false) { show_alert('#{escape_javascript self.alert }'); }"
    	when /show|hide/
	    	"$('#{ js_target_element }_container').#{action}();" if js_target_element
	    when /enable|disable/
	    	"enable_disable_element('#{ js_target_element }_container', '#{action}');" if js_target_element
		end
	end

	# From the class-level enum "action_types" determine what the opposite
	# action would be. This is done by going back one item for odd numbered
	# entries (starting with zero), otherwise forward one item. This leaves 
	# the last item without an opposite action if it has a positive index.
	#
	def opposite_action
		i = self.class.action_types[self.action_type]
		o = (i%2 > 0) ? i - 1 : i + 1
		self.class.action_types.invert[o]
	end

	def js_target_element
		if system_option
			if system_option_value
				"#system_option_value_#{system_option_value_id}"
			else
				"#system_option_#{system_option_id}"
			end
		else
			false
		end
	end
end
