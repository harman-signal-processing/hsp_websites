# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :brand_toolkit_contact do
    brand
    user
    position 1
  end
end
