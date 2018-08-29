# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :system_rule_condition do
    system_rule_condition_group
    system_option
    operator { "MyString" }
    system_option_value
    direct_value { "MyString" }
    logic_type { "MyString" }
  end
end
