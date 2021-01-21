FactoryBot.define do
  factory :address do
    addressable_id { 1 }
    addressable_type { "User" }
    name { "Some Name" }
    street_1 { "1234 Rodeo Drive" }
    locality { "Los Angeles" }
    region { "CA" }
    postal_code { "90210" }
    country { "US" }
  end
end
