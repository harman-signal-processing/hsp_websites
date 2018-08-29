# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :system do
    name { "MyString" }
    brand
    description { "MyText" }
  end
end
