# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :system_configuration do
    system
    name "MyString"
    user
  end
end
