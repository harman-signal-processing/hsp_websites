class AddMarketingCalendarToMarketingProjects < ActiveRecord::Migration
  def change
    add_column :marketing_projects, :marketing_calendar_id, :integer
    add_index :marketing_projects, :marketing_calendar_id
  end
end
