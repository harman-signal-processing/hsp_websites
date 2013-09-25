class CreateMarketingProjects < ActiveRecord::Migration
  def change
    create_table :marketing_projects do |t|
      t.string :name
      t.integer :brand_id
      t.integer :user_id
      t.integer :marketing_project_type_id
      t.date :event_start_on
      t.date :event_end_on
      t.string :targets
      t.string :targets_progress
      t.float :estimated_cost

      t.timestamps
    end
    add_index :marketing_projects, :brand_id
    add_index :marketing_projects, :user_id
    add_index :marketing_projects, :marketing_project_type_id
  end
end
