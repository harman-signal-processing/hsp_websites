# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :system_rule_condition_group do
    system_rule
    logic_type "Boolean"
  end
end
