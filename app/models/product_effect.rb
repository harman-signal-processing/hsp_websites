class ProductEffect < ApplicationRecord
  belongs_to :product, touch: true
  belongs_to :effect
  validates :effect_id, uniqueness: { scope: :product_id, case_sensitive: false }
end
