class CreateMarketingTasks < ActiveRecord::Migration
  def change
    create_table :marketing_tasks do |t|
      t.string :name
      t.integer :marketing_project_id
      t.integer :brand_id
      t.date :due_on
      t.integer :requestor_id
      t.integer :worker_id
      t.datetime :completed_at

      t.timestamps
    end
    add_index :marketing_tasks, :marketing_project_id
    add_index :marketing_tasks, :brand_id
    add_index :marketing_tasks, :requestor_id
    add_index :marketing_tasks, :worker_id
  end
end
