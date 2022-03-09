class ProductInnovation < ApplicationRecord
  belongs_to :product
  belongs_to :innovation
  
  validates :product, uniqueness: { scope: :innovation_id }, presence: true
  validates :innovation, presence: true
end
