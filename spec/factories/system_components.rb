# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :system_component do
    name { "MyString" }
    system
    product
    description { "MyText" }
  end
end
