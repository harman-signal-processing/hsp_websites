class ProductFamilyProductFilter < ApplicationRecord
  belongs_to :product_family
  belongs_to :product_filter
  acts_as_list scope: :product_family
  validates :product_filter, uniqueness: { scope: :product_family, case_sensitive: false }
end
