# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :us_rep do
    sequence(:name) {|n| "Super Rep #{n}"}
    contact "Joey"
    address "123 Street"
    city "Salt Lake City"
    state "UT"
    zip "84011"
    phone "801-555-5555"
    fax "801-555-5556"
    email "joey@bestrepever.com"
  end
end
