class AddProjectTypeToMarketingProjectTypeTasks < ActiveRecord::Migration
  def change
    add_column :marketing_project_type_tasks, :marketing_project_type_id, :integer
    add_index :marketing_project_type_tasks, :marketing_project_type_id
  end
end
