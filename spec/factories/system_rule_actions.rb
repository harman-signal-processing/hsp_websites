# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :system_rule_action do
    system_rule_id { 1 }
    action_type { "MyString" }
    system_option_id { 1 }
    system_option_value_id { 1 }
    alert { "MyText" }
  end
end
