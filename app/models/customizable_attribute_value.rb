class CustomizableAttributeValue < ApplicationRecord
  belongs_to :product
  belongs_to :customizable_attribute

  validates :value, presence: true, uniqueness: { scope: [:product_id, :customizable_attribute_id] }

  def label
    comment.present? ? "#{value} - #{comment}" : value
  end
end
