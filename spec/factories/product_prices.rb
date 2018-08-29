# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :product_price do
    product
    pricing_type
    price_cents { 19900 }
  end
end
