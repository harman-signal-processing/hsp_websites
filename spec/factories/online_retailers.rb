FactoryBot.define do

  factory :online_retailer do
    sequence(:name) {|n| "Musicians Enemy #{n}"}
    active { true }
    preferred { nil }
  end

  factory :online_retailer_link do
    product
    online_retailer
    brand
    url { 'http://nuthin.lvh.me/bla/bla.html' }
  end

end
