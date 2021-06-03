FactoryBot.define do
  factory :custom_shop_quote_line_item_attribute do
    custom_shop_quote_line_item
    customizable_attribute
    value { "MyString" }
  end
end
