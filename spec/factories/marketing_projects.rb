# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :marketing_project do
    name "MyString"
    brand
    user
    marketing_project_type
    due_on 1.month.from_now
    event_start_on 1.month.from_now
    event_end_on 2.months.from_now
    targets "MyString"
    targets_progress "MyString"
    estimated_cost 1.5
  end
end
