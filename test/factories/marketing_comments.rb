# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :marketing_comment do
    marketing_project
    user
    message "MyText"
  end
end
