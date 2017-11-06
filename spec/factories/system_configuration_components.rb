# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :system_configuration_component do
    system_configuration
    system_component
    quantity 1
  end
end
