# SystemRuleCondition belongs to a group, which belongs to a rule, which belong to
# a system. These are used in the system configuration tool to determine when to
# show/hide dependent options or show an alert. The action is determined by the
# related SystemRuleAction.
#
class SystemRuleCondition < ActiveRecord::Base
	enum logic_types: ["AND", "OR"]

	belongs_to :system_rule_condition_group
	belongs_to :system_option
	belongs_to :system_option_value

	validates :system_rule_condition_group, presence: true
	validates :system_option, presence: true
	# One or the other of these...
	# validates :system_option_value, presence: true
	# validates :direct_value, presence: true
	validates :operator, presence: true
	validates :logic_type, presence: true

	after_initialize :set_default_logic_type

	def self.operators
		# ['=', '<', '>', '!=']
		['is', 'is not', 'is greater than', 'is less than']
	end

	def set_default_logic_type
		self.logic_type ||= "OR"
	end

	def to_s
		logic = self.is_first? ? '' : "#{self.logic_type} "
		"#{logic}'#{system_option.name}' #{operator} #{direct_value}"
	end

	def to_js
		logic = self.is_first? ? '' : " #{ js_logic_type } "
		js = case system_option.option_type.parameterize
			when 'boolean'
				onoff = direct_value.to_s.match(/true/i) || direct_value.to_i > 0 ? ':checked' : ':not(:checked)'
				"$('#system_option_#{ system_option_id }').is('#{ onoff }')"
      when 'integer'
      	"parseInt($('#system_option_#{ system_option_id }').val(), 10) #{ js_operator } #{ direct_value }"
      when 'string'
        "$('#system_option_#{ system_option_id }').val() #{ js_operator } '#{ direct_value }'"
      when 'radio'
      	"parseInt($('#system_option_#{ system_option_id }:checked').val(), 10) #{ js_operator } #{ direct_value }"
      when 'checkbox'
        if direct_value.match(/^\d{1,}$/)
          "$('#system_option_#{ system_option_id }[type=\"checkbox\"]').filter(':checked').length #{ js_operator } #{ direct_value }"
        else
          "$('#system_option_#{ system_option_id }').is(':checked')"
        end
      when 'dropdown'
      	if direct_value.match(/^[\d\.]{1,}$/)
        	"parseInt($('#system_option_#{ system_option_id } option:selected').text(), 10) #{ js_operator } #{ direct_value }"
        else
        	"$('#system_option_#{ system_option_id } option:selected').text() #{ js_operator } '#{ direct_value }'"
        end
      # An attempt to handle multi_dropdowns differently...
      #when 'multi_dropdown'
      #  "$('*[data-multiname=\"multiselect_#{ system_option_id }\"]').filter(function(){ $(this, 'option:selected').length > 0 }).length #{ js_operator } '#{ direct_value }'"
      else
      	"$('#system_option_#{ system_option_id }').val() #{ js_operator } '#{ direct_value }'"
    end
    "#{logic} #{js}"
	end

	def js_operator
		case self.operator
		when 'is'
			'=='
		when 'is not'
			'!='
		when 'is greater than'
			'>'
		when 'is less than'
			'<'
		end
	end

	def js_logic_type
		self.logic_type.to_s.match(/AND/i) ? '&&' : '||'
	end

	def is_first?
		self.system_rule_condition_group.system_rule_conditions.first == self
	end

	# Just check if the object is good enough to be created as a nested element of a new
	# SystemRuleConditionGroup
	#
	def valid_for_nested_creation?
		self.operator.present? && self.logic_type.present? && self.system_option_id.present?
	end
end
