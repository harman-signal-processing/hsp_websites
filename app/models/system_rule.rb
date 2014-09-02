# SystemRule is a combination of conditions and actions that happen when those
# conditions are met. The conditions are organized into groups so different
# types of operator logic can be applied.
#
class SystemRule < ActiveRecord::Base
	belongs_to :system
	has_many :system_rule_condition_groups
	has_many :system_rule_actions

	validates :system, presence: true

	accepts_nested_attributes_for :system_rule_condition_groups, reject_if: :all_blank
	accepts_nested_attributes_for :system_rule_actions, reject_if: :all_blank
end
