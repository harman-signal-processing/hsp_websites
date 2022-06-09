class CreateScheduledTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :scheduled_tasks do |t|
      t.datetime :perform_at
      t.references :schedulable, polymorphic: true
      t.string :status

      t.timestamps
    end
  end
end
