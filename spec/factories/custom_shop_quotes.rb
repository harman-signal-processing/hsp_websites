FactoryBot.define do
  factory :custom_shop_quote do
    uuid { "MyString" }
    user
    account_number { "MyString" }
    opportunity_number { "MyString" }
    opportunity_name { "MyString" }
    location { "MyString" }
    description { "MyText" }
    request_delivery_on { 6.months.from_now }

    factory :custom_shop_quote_with_line_items do
      after(:create) do |custom_shop_quote|
        product = create(:product)
        create_list(:custom_shop_quote_line_item, 2, custom_shop_quote: custom_shop_quote, product: product)
      end
    end
  end
end
