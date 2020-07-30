class ProductFamilyProductFilter < ApplicationRecord
  belongs_to :product_family
  belongs_to :product_filter
  acts_as_list scope: :product_family
  validates :product_filter, presence: true, uniqueness: { scope: :product_family, case_sensitive: false }
  validates :product_family, presence: true
end
