class ProductPrice < ActiveRecord::Base
  attr_accessible :price_cents, :pricing_type_id, :product_id
  monetize :price_cents
end
