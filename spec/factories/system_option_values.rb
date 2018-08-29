# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :system_option_value do
    system_option
    name { "MyString" }
    position { 1 }
    description { "MyText" }
    default { false }
    price { 1 }
  end
end
