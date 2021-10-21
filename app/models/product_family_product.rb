class ProductFamilyProduct < ApplicationRecord
  belongs_to :product_family, touch: true, counter_cache: true, inverse_of: :product_family_products
  belongs_to :product, touch: true
  acts_as_list scope: :product_family_id
  validates :product_family_id, presence: true
  validates :product_id, presence: true, uniqueness: { scope: :product_family_id, case_sensitive: false }
end
