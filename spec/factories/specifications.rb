FactoryGirl.define do
  factory :specification do
  	sequence(:name) {|n| "Specification #{n}"}
  end
end
