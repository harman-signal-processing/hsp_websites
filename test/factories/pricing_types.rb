# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pricing_type do
    name "MyString"
    brand_id 1
    pricelist_order 1
    calculation_method "MyString"
  end
end
