class ProductBadge < ApplicationRecord
  belongs_to :badge
  belongs_to :product

  validates :product_id, uniqueness: { scope: :badge_id, case_sensitive: false }
end
