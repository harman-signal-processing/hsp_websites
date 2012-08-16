class ProductSpecification < ActiveRecord::Base
  belongs_to :product, touch: true
  belongs_to :specification
  acts_as_list scope: :product_id
  validates_uniqueness_of :specification_id, scope: :product_id
  validates_presence_of :value
end
