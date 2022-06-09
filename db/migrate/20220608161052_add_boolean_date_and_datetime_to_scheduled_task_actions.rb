class AddBooleanDateAndDatetimeToScheduledTaskActions < ActiveRecord::Migration[6.1]
  def change
    add_column :scheduled_task_actions, :new_boolean_value, :boolean
    add_column :scheduled_task_actions, :new_date_value, :date
    add_column :scheduled_task_actions, :new_datetime_value, :datetime
  end
end
