class ProductPrice < ActiveRecord::Base
  attr_accessible :price_cents, :pricing_type_id, :product_id
  belongs_to :product
  belongs_to :pricing_type 
  monetize :price_cents
end
