class ProductSpecification < ApplicationRecord
  belongs_to :product, touch: true
  belongs_to :specification
  acts_as_list scope: :product_id
  validates :specification_id, uniqueness: { scope: :product_id }, presence: true
  validates :value, presence: true

  def content_name
    specification.name
  end
end
