FactoryBot.define do
  factory :custom_shop_cart do
    uuid { "MyString" }
    factory :custom_shop_cart_with_line_items do
      after(:create) do |custom_shop_cart|
        product = create(:product)
        create_list(:custom_shop_line_item, 2, custom_shop_cart: custom_shop_cart, product: product)
      end
    end
  end
end
