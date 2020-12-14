FactoryBot.define do
  factory :product_key do
    key { SecureRandom.hex(13) }
    email { "MyString" }
    user
    sales_order_id { 1 }
    product
  end
end
