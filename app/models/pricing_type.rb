class PricingType < ActiveRecord::Base
  attr_accessible :brand_id, :calculation_method, :name, :pricelist_order
end
