class ProductFamilyCustomizableAttribute < ApplicationRecord
  belongs_to :product_family
  belongs_to :customizable_attribute

  validates :product_family, presence: true
  validates :customizable_attribute, presence: true, uniqueness: { scope: :product_family_id }
end
