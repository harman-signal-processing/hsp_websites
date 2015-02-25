FactoryGirl.define do
  factory :faq do
    sequence(:question) {|n|  "Question ##{n}?"}
    answer "It's time for lunch."
  end
end
