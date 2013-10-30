class AddManHoursToMarketingTask < ActiveRecord::Migration
  def change
    add_column :marketing_tasks, :man_hours, :float
  end
end
