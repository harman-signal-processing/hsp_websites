# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :toolkit_resource_type do
    name { "MyString" }
    position { 1 }
    related_model { "MyString" }
    related_attribute { "MyString" }
  end
end
