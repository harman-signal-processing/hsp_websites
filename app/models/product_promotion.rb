class ProductPromotion < ApplicationRecord
  belongs_to :product, touch: true
  belongs_to :promotion, touch: true
  validates :product, uniqueness: { scope: :promotion_id, case_sensitive: false }
end
