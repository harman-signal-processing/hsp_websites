class CustomizableAttribute < ApplicationRecord
  has_many :product_family_customizable_attributes, dependent: :destroy
  has_many :product_families, through: :product_family_customizable_attributes

end
