class ProductSoftware < ApplicationRecord
  default_scope { order("software_position") }
  belongs_to :product, touch: true
  belongs_to :software, touch: true
  validates :product_id, presence: true
  validates :software_id, presence: true, uniqueness: { scope: :product_id }
end
