class AddPriorityToMarketingTasks < ActiveRecord::Migration
  def change
    add_column :marketing_tasks, :priority, :integer
  end
end
