class AddCurrentlyWithToMarketingTasks < ActiveRecord::Migration
  def change
    add_column :marketing_tasks, :currently_with_id, :integer
  end
end
