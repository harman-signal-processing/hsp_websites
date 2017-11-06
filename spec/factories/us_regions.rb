# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :us_region do
    sequence(:name) {|n| "Region #{n}"}
  end
end
