# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :system_option do
    system_id 1
    name "MyString"
    option_type "MyString"
    position 1
    parent_id 1
    description "MyText"
  end
end
