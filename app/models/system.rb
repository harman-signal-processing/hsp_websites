# System is used to configure IDX (and possibly other) systems. It consists of nested
# options and values. Selected values may trigger one or more SystemActions.
#
class System < ActiveRecord::Base
	has_many :system_options
	has_many :system_rules
	belongs_to :brand

	validates :brand, presence: true
	validates :name, presence: true, uniqueness: { scope: :brand_id }

	def options_with_possible_values
		option_ids = SystemOptionValue.where(id: self.system_options).pluck(:system_option_id).uniq
		system_options.where(id: option_ids)
	end
end
