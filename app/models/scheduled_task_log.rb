class ScheduledTaskLog < ApplicationRecord
  belongs_to :scheduled_task
  belongs_to :scheduled_task_action
end
