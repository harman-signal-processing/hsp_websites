FactoryBot.define do
  factory :banner do
    name { "MyString" }
    bannerable { nil }
    start_on { 1.week.ago }
    remove_on { 1.week.from_now }
  end
end
