class BrandSolution < ApplicationRecord
  belongs_to :brand
  belongs_to :solution

  validates :solution, uniqueness: { scope: :brand_id, case_sensitive: false }
end
