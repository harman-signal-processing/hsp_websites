class ProductSpecification < ApplicationRecord
  belongs_to :product, touch: true
  belongs_to :specification, inverse_of: :product_specifications
  acts_as_list scope: :product_id
  validates :specification, uniqueness: { scope: :product_id, case_sensitive: false }, presence: true
  validates :value, presence: true

  accepts_nested_attributes_for :specification, reject_if: :all_blank

  after_save ThinkingSphinx::RealTime.callback_for(:product, [:product])

  def content_name
    specification.name
  end

end
