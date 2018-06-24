class ProductBadge < ApplicationRecord
  belongs_to :badge
  belongs_to :product

  validates :badge_id, presence: true
  validates :product_id, presence: true, uniqueness: { scope: :badge_id }
end
