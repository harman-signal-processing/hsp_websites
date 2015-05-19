# SystemOptionValue is a set of answers to a given SystemOption question. Depending
# on the SystemOption#option_type, there may be more than one selected value.
# Selecting/de-selecting values may trigger certain SystemRuleActions and should
# alter the total_price for the System.
#
class SystemOptionValue < ActiveRecord::Base
	belongs_to :system_option
  has_many :system_configuration_option_values, inverse_of: :system_option_value

	monetize :price_cents

	validates :name, presence: true, uniqueness: { scope: :system_option_id }

	acts_as_list scope: :system_option_id
end
