FactoryBot.define do
  factory :custom_shop_quote do
    user
    custom_shop_cart
    account_number { "MyString" }
    opportunity_number { "MyString" }
    opportunity_name { "MyString" }
    location { "MyString" }
    description { "MyText" }
    request_delivery_on { 6.months.from_now }

  end
end
