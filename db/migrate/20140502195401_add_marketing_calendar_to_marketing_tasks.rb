class AddMarketingCalendarToMarketingTasks < ActiveRecord::Migration
  def change
    add_column :marketing_tasks, :marketing_calendar_id, :integer
    add_index :marketing_tasks, :marketing_calendar_id
  end
end
