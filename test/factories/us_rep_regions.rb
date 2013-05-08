# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :us_rep_region do
    us_rep
    us_region
    brand
  end
end
