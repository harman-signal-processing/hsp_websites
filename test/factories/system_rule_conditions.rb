# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :system_rule_condition do
    system_rule_condition_group_id 1
    system_option_id 1
    operator "MyString"
    system_option_value_id 1
    direct_value "MyString"
    logic_type "MyString"
  end
end
