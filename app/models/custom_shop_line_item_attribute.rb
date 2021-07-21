class CustomShopLineItemAttribute < ApplicationRecord
  belongs_to :custom_shop_line_item
  belongs_to :customizable_attribute

#  validates :custom_shop_line_item, presence: true
  validates :customizable_attribute, presence: true
  validates :value, presence: true

  def options_for(product)
    product.customizable_attribute_values.where(customizable_attribute: customizable_attribute).map do |cav|
      [cav.label, cav.value]
    end
  end

end
