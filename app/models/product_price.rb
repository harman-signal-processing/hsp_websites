class ProductPrice < ActiveRecord::Base
  attr_accessible :price_cents, :price, :pricing_type_id, :product_id
  belongs_to :product
  belongs_to :pricing_type 
  monetize :price_cents
  validates :product_id, presence: true, uniqueness: {scope: :pricing_type_id}
  validates :pricing_type_id, presence: true
end
