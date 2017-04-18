class ProductCabinet < ApplicationRecord
  belongs_to :product, touch: true
  belongs_to :cabinet
  validates :product_id, presence: true
  validates :cabinet_id, presence: true, uniqueness: { scope: :product_id }
end
