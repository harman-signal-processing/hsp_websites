class CustomizableAttribute < ApplicationRecord
  has_many :product_family_customizable_attributes, dependent: :destroy
  has_many :product_families, through: :product_family_customizable_attributes

  scope :not_associated_with_product_family, -> (product_family) {
    where.not(id: ProductFamilyCustomizableAttribute.where(product_family: product_family).pluck(:customizable_attribute_id))
  }

  def options_for_product(product)
    product.customizable_attribute_values.where(customizable_attribute: self)
  end
end
