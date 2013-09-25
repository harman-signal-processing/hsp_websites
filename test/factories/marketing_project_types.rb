# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :marketing_project_type do
    sequence(:name) {|n| "Marketing Project Type #{n}"}
    major_effort false
  end
end
