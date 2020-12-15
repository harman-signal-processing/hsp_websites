class ProductSoftware < ApplicationRecord
  default_scope { order("software_position") }
  belongs_to :product, touch: true
  belongs_to :software, touch: true, inverse_of: :product_softwares
  validates :product_id, presence: true
  validates :software, presence: true, uniqueness: { scope: :product_id, case_sensitive: false }
end
