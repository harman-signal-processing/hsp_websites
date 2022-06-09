FactoryBot.define do
  factory :scheduled_task do
    perform_at { 2.days.from_now.to_time } 
    schedulable { nil }
  end
end
