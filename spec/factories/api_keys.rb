# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :api_key do
    access_token { "MyString" }
  end
end
