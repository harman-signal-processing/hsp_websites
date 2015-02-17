FactoryGirl.define do
  factory :market_segment do
    sequence(:name) {|n| "Vertical Market ##{n}"}
    brand
  end
end
