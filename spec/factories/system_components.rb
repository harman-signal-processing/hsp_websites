# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :system_component do
    name "MyString"
    system
    product
    description "MyText"
  end
end
