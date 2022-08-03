class ProductFamilyCustomizableAttribute < ApplicationRecord
  belongs_to :product_family
  belongs_to :customizable_attribute

  validates :customizable_attribute, uniqueness: { scope: :product_family_id }
end
