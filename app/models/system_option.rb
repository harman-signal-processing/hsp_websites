# SystemOption belongs to a master System. These options are arranged in a tree hierarchy. 
# Certain options may be hidden by default, only to appear if certain SystemRules are met.
# This is usually based on the selected SystemOptionValue for the given SystemOption.
#
class SystemOption < ActiveRecord::Base
	enum option_types: [:boolean, :radio, :check_box, :range, :integer, :string]

	belongs_to :system
	has_many :system_option_values

	validates :system, presence: true
	validates :name, presence: true

	acts_as_tree
	acts_as_list scope: :parent_id
end
