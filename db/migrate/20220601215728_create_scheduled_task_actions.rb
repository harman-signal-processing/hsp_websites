class CreateScheduledTaskActions < ActiveRecord::Migration[6.1]
  def change
    create_table :scheduled_task_actions do |t|
      t.integer :scheduled_task_id
      t.string :field_name
      t.string :field_type
      t.integer :new_integer_value
      t.string :new_string_value
      t.text :new_text_value
      t.string :status

      t.timestamps
    end
    add_index :scheduled_task_actions, :scheduled_task_id
  end
end
