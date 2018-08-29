FactoryBot.define do
  factory :product_specification do
    product
    specification
    value { "spec-value" }
  end
end
