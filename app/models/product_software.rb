class ProductSoftware < ApplicationRecord
  default_scope { order("software_position") }
  belongs_to :product, touch: true
  belongs_to :software, touch: true, inverse_of: :product_softwares
  validates :software, uniqueness: { scope: :product_id, case_sensitive: false }
end
