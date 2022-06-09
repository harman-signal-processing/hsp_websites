FactoryBot.define do
  factory :scheduled_task_log do
    scheduled_task
    scheduled_task_action
    description { "MyText" }
  end
end
