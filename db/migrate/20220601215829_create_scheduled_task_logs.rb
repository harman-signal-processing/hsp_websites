class CreateScheduledTaskLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :scheduled_task_logs do |t|
      t.integer :scheduled_task_id
      t.integer :scheduled_task_action_id
      t.text :description

      t.timestamps
    end
    add_index :scheduled_task_logs, :scheduled_task_id
    add_index :scheduled_task_logs, :scheduled_task_action_id
  end
end
