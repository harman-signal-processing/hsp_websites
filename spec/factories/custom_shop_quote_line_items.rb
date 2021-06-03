FactoryBot.define do
  factory :custom_shop_quote_line_item do
    custom_shop_quote
    product
    quantity { 1 }
  end
end
