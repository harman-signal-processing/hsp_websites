class Specification < ActiveRecord::Base
  belongs_to :product_specification
  validates_uniqueness_of :name
  validates_presence_of :name
  has_many :product_specifications
  has_friendly_id :name, use_slug: true, approximate_ascii: true, max_length: 100
  
  def values_with_products
    r = {}
    product_specifications.each do |product_specification|
      r[product_specification.value] ||= []
      r[product_specification.value] << product_specification.product
    end
    r
  end
end
