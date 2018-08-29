# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :dealer do
    sequence(:name) {|n| "Dealer #{n}" }
    address { "123 Street" }
    city { "SomeCity" }
    state { "UT" }
    zip { "84070" }
    telephone { "555-555-5555" }
    fax { "555-555-5556" }
    sequence(:email) {|n| "dealer#{n}@something.com"}
    sequence(:account_number) {|n| ("%010d" % n).to_s}
  end
end

FactoryBot.define do
  factory :dealer_user do
    dealer
    user
  end
end
