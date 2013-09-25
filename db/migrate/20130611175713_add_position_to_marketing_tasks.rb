class AddPositionToMarketingTasks < ActiveRecord::Migration
  def change
    add_column :marketing_tasks, :position, :integer
  end
end
