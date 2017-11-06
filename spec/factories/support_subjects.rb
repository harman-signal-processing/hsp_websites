FactoryBot.define do
  factory :support_subject do
    brand
    sequence(:name) {|n| "Support Subject #{n}"}
  end

end
