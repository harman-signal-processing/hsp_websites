# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :system_configuration_option do
    system_configuration
    system_option
    system_option_value
    direct_value { "MyString" }
  end
end
