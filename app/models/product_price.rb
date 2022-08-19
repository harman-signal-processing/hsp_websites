class ProductPrice < ApplicationRecord
  belongs_to :product
  belongs_to :pricing_type
  monetize  :price_cents
  validates :product_id, uniqueness: {scope: :pricing_type_id}

end
