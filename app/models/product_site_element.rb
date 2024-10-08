class ProductSiteElement < ApplicationRecord
  belongs_to :site_element, inverse_of: :product_site_elements
  belongs_to :product, inverse_of: :product_site_elements, touch: true
  validates :product_id, uniqueness: { scope: :site_element_id, case_sensitive: false }
end
