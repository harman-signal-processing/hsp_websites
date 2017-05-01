# SystemRuleAction is something triggered by one or more SystemRuleCondition as part
# of a System configuration. The action can be either show/hide an option/value or
# show an alert.
#
class SystemRuleAction < ApplicationRecord
	include ActionView::Helpers::JavaScriptHelper

	belongs_to :system_rule

	# Will have at least one of: option, value, alert (text), component
	belongs_to :system_option
	belongs_to :system_option_value
	belongs_to :system_component
	# validates :alert, presence: true # only if neither option nor value ids present

	validates :action_type, presence: true
	validates :system_rule, presence: true

	def self.action_types
		{
			show:       {opposite: :hide, dependent_fields: [:system_option_id, :system_option_value_id]},
			hide:       {opposite: :show, dependent_fields: [:system_option_id, :system_option_value_id]},
			enable:     {opposite: :disable, dependent_fields: [:system_option_id, :system_option_value_id]},
			disable:    {opposite: :enable, dependent_fields: [:system_option_id, :system_option_value_id]},
			add:        {opposite: :subtract, dependent_fields: [:system_component_id, :quantity]},
			subtract:   {opposite: :add, dependent_fields: [:system_component_id, :quantity]},
			set:        {opposite: :remove, dependent_fields: [:system_component_id, :quantity]},
			remove:     {opposite: nil, dependent_fields: [:system_component_id]},
      remove_all_components: {opposite: nil, dependent_fields: []},
#      add_with_ratio: {opposite: :remove, dependent_fields: [:system_component_id, :system_option_id, :quantity]},
      set_with_ratio: {opposite: :remove, dependent_fields: [:system_component_id, :system_option_id, :ratio]},
			alert_once: {opposite: nil, dependent_fields: [:alert]},
			alert:      {opposite: nil, dependent_fields: [:alert]},
		}
	end

	# Inverted way of looking at SystemRuleAction.action_types
	def self.related_actions_for(opt)
		r = []
		self.action_types.each do |key,action_type|
			r << key if action_type[:dependent_fields].include?(opt)
		end
		r.join(',')
	end

	def to_s
		case action_type
		when 'alert'
			"show alert: '#{self.alert.truncate(30).html_safe }'"
		when 'alert_once'
			"show alert one time: '#{self.alert.truncate(30).html_safe }'"
		when /enable|disable|show|hide/
			"#{action_type} #{system_option ? system_option.name : ''}"
		when /add|subtract|set/
      "#{action_type} #{system_component ? system_component.name : ''} (qty: #{action_type.match(/ratio/) ? ratio : quantity})"
		when "remove"
			"#{action_type} #{system_component ? system_component.name : ''}"
		end
	end

	def to_js(options={})
		action = (options[:opposite] == true) ? opposite_action : action_type

		case action
			when 'alert'
        # commented version doesn't show alerts on page load
      	#"if (page_loading == false) { show_alert('alert_#{self.id}', true); }"
      	"show_alert('alert_#{self.id}', true);"
      when 'alert_once'
        # commented version doesn't show alerts on page load
      	#"if (page_loading == false) { show_alert('alert_#{self.id}', false); }"
      	"show_alert('alert_#{self.id}', false);"
    	when /show|hide/
	    	"$('#{ js_target_element }_container').#{action}();" if js_target_element
	    when /enable|disable/
	    	"enable_disable_element('#{ js_target_element }_container', '#{action}');" if js_target_element
	    when /ratio/
        "#{action}_component('component_#{system_component_id}', '#{ratio}', '#system_option_#{system_option_id}', '#{system_option.option_type}');"
      when /add|set/
	    	"#{action}_component('component_#{system_component_id}', #{quantity});"
	    when /subtract/ # don't subtract the first time through
	    	"if (page_loading == false) { #{action}_component('component_#{system_component_id}', #{quantity}); }"
      when "remove_all_components"
        "if (page_loading == false) { remove_all_components(); }"
	    when /remove/
	    	"if (page_loading == false) {#{action}_component('component_#{system_component_id}'); }"
		end
	end

	# From the class-level enum "action_types" determine what the opposite
	# action would be.
	#
	def opposite_action
		self.class.action_types[self.action_type.to_sym][:opposite]
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
