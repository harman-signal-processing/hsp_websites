FactoryBot.define do
  factory :product_stock_subscription do
    user
    product
    low_stock_level { 10 }
  end
end
