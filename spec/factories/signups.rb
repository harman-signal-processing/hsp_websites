# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :signup do
    email { "name@email.com" }
    campaign { "MyString" }
    brand
  end
end
