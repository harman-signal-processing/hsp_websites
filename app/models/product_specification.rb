class ProductSpecification < ApplicationRecord
  belongs_to :product, touch: true
  belongs_to :specification, inverse_of: :product_specifications
  acts_as_list scope: :product_id
  validates :specification_id, uniqueness: { scope: :product_id }, presence: true
  validates :value, presence: true

  accepts_nested_attributes_for :specification, reject_if: :all_blank

  def content_name
    specification.name
  end
end
