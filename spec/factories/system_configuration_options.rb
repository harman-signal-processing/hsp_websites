# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :system_configuration_option do
    system_configuration_id 1
    system_option_id 1
    system_option_value_id 1
    direct_value "MyString"
  end
end
