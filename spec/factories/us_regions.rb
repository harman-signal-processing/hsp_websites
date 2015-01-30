# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :us_region do
    sequence(:name) {|n| "Region #{n}"}
  end
end
