class BrandSpecificationForComparison < ApplicationRecord
  belongs_to :brand
  belongs_to :specification
  acts_as_list scope: :brand

  validates :brand, presence: true
  validates :specification, presence: true, uniqueness: { scope: :brand }
end
