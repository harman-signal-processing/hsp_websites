# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :system_option do
    system
    name "MyString"
    option_type "MyString"
    position 1
    parent
    description "MyText"
  end
end
