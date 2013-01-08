# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product_price do
    product_id 1
    pricing_type_id 1
    price_cents ""
  end
end
