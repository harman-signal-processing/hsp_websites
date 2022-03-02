FactoryBot.define do
  factory :software_report do
    software
    previous_count { 1 }
    previous_count_on { 1.month.ago }
  end
end
