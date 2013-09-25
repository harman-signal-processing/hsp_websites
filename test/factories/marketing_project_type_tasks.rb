# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :marketing_project_type_task do
    name "MyString"
    position 1
    marketing_project_type
  end
end
