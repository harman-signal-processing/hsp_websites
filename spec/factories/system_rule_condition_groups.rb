# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :system_rule_condition_group do
    system_rule
    logic_type "Boolean"
  end
end
