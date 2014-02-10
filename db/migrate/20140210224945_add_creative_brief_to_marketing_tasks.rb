class AddCreativeBriefToMarketingTasks < ActiveRecord::Migration
  def change
    add_column :marketing_tasks, :creative_brief, :text
  end
end
