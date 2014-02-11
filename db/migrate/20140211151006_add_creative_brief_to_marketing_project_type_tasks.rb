class AddCreativeBriefToMarketingProjectTypeTasks < ActiveRecord::Migration
  def change
    add_column :marketing_project_type_tasks, :creative_brief, :text
  end
end
