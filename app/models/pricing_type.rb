class PricingType < ActiveRecord::Base
  attr_accessible :calculation_method, :name, :pricelist_order
  validates :name, presence: true, uniqueness: { scope: :brand_id }
  belongs_to :brand
end
