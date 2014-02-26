class ProductSpecification < ActiveRecord::Base
  belongs_to :product, touch: true
  belongs_to :specification
  acts_as_list scope: :product_id
  validates :specification_id, uniqueness: { scope: :product_id }, presence: true
  validates :value, presence: true
end
