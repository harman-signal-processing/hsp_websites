# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :pricing_type do
    sequence(:name) {|n| "Special Price #{n}"}
    brand
    pricelist_order { 1 }
    calculation_method { "MAP - 10%" }
  end
end
