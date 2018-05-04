class ProductPart < ApplicationRecord
  belongs_to :product
  belongs_to :part

  validates :part, presence: true, uniqueness: { scope: :product_id }
  validates :product, presence: true
end
