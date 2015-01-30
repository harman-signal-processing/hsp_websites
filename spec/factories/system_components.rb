# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :system_component do
    name "MyString"
    system_id 1
    product_id 1
    description "MyText"
  end
end
