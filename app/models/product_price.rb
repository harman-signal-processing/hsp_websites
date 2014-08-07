class ProductPrice < ActiveRecord::Base
  belongs_to :product
  belongs_to :pricing_type 
  monetize  :price_cents
  validates :product_id, presence: true, uniqueness: {scope: :pricing_type_id}
  validates :pricing_type_id, presence: true

end
