FactoryBot.define do
  factory :custom_shop_line_item do
    custom_shop_cart
    product
    quantity { 1 }
  end
end
