# SystemRule is a combination of conditions and actions that happen when those
# conditions are met. The conditions are organized into groups so different
# types of operator logic can be applied.
#
class SystemRule < ActiveRecord::Base
	belongs_to :system
	has_many :system_rule_condition_groups
	has_many :system_rule_actions

	validates :system, presence: true
end
