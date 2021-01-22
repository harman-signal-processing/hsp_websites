FactoryBot.define do
  factory :address do
    addressable_id { 1 }
    addressable_type { "User" }
    name { "Harman" }
    street_1 { "8500 Balboa Blvd" }
    locality { "Northridge" }
    region { "CA" }
    postal_code { "91329" }
    country { "United States of America" }
  end
end
