# SystemOption belongs to a master System. These options are arranged in a tree hierarchy.
# Certain options may be hidden by default, only to appear if certain SystemRules are met.
# This is usually based on the selected SystemOptionValue for the given SystemOption.
#
class SystemOption < ApplicationRecord
	enum option_types: [:boolean, :radio, :checkbox, :integer, :string, :dropdown, :multi_dropdown]

	belongs_to :system
	has_many :system_option_values, dependent: :destroy
	has_many :system_rule_conditions, dependent: :destroy
  has_many :system_configuration_options, inverse_of: :system_option

	validates :name, presence: true
	validates :option_type, presence: true

	acts_as_tree order: :position, scope: :parent_id

	accepts_nested_attributes_for :system_option_values, reject_if: :all_blank, allow_destroy: true

	def self.all_with_values
		ids = SystemOptionValue.where.not(system_option_id: nil).pluck(:system_option_id).uniq
		where(id: ids).order('name')
	end

	def system_rules
		@system_rules ||= enabled_system_rule_conditions.map{|src| src.system_rule_condition_group.system_rule }.uniq
	end

  def enabled_system_rule_conditions
    @enabled_system_rule_conditions ||= system_rule_conditions.select{|src| src if src.system_rule_condition_group.system_rule.enabled? }
  end

	def default_direct_value
		case option_type
			when 'boolean'
				(default_value == true || default_value.to_s.match(/true|1/i)) ? true : false
			when 'integer'
				default_value.to_i
			else
				default_value.to_s
		end
	end

  def default_system_option_value_id
    begin
      if has_many_values?
        system_option_values.find_by(name: default_value.to_s).id
      else
        nil
      end
    rescue
      nil
    end
  end

  def has_many_values?
    !!option_type.to_s.match(/dropdown|radio|checkbox/)
  end

end
