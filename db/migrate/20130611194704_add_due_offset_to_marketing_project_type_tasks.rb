class AddDueOffsetToMarketingProjectTypeTasks < ActiveRecord::Migration
  def change
    add_column :marketing_project_type_tasks, :due_offset_number, :integer
    add_column :marketing_project_type_tasks, :due_offset_unit, :string
  end
end
