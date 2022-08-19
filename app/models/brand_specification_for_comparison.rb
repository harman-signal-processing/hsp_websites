class BrandSpecificationForComparison < ApplicationRecord
  belongs_to :brand
  belongs_to :specification
  acts_as_list scope: :brand

  validates :specification, uniqueness: { scope: :brand, case_sensitive: false }
end
