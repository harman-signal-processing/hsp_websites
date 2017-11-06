# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :us_rep_region do
    us_rep
    us_region
    brand
  end
end
