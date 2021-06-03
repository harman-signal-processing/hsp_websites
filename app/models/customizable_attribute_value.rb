class CustomizableAttributeValue < ApplicationRecord
  belongs_to :product
  belongs_to :customizable_attribute

  validates :product, presence: true
  validates :customizable_attribute, presence: true
  validates :value, presence: true, uniqueness: { scope: [:product_id, :customizable_attribute_id] }
end
