class CustomShopQuoteLineItemAttribute < ApplicationRecord
  belongs_to :custom_shop_quote_line_item, foreign_key: 'line_item_id'
  belongs_to :customizable_attribute

#  validates :custom_shop_quote_line_item, presence: true
  validates :customizable_attribute, presence: true
  validates :value, presence: true

  def options_for(product)
    product.customizable_attribute_values.where(customizable_attribute: customizable_attribute).pluck(:value)
  end

end
