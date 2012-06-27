class ProductSiteElement < ActiveRecord::Base
  belongs_to :site_element, :inverse_of => :product_site_elements
  belongs_to :product, :inverse_of => :product_site_elements, touch: true
  validates :site_element, :product, :presence => true
  validates :product_id, :uniqueness => { :scope => :site_element_id }
end
