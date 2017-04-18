class ProductPromotion < ApplicationRecord
  belongs_to :product, touch: true
  belongs_to :promotion, touch: true
  validates :promotion_id, presence: true
  validates :product_id, presence: true, uniqueness: { scope: :promotion_id }
end
