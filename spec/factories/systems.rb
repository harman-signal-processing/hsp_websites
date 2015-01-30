# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :system do
    name "MyString"
    brand_id 1
    description "MyText"
  end
end
