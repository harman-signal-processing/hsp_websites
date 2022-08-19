FactoryBot.define do
  factory :brand_dealer_rental_product do
    product
    brand_dealer
    position { 1 }
  end
end
