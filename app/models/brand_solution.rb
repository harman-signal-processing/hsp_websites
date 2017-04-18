class BrandSolution < ApplicationRecord
  belongs_to :brand
  belongs_to :solution

  validates :brand, presence: true
  validates :solution, presence: true, uniqueness: { scope: :brand_id }
end
