class AddLockPanelsToGetStartedPages < ActiveRecord::Migration
  def change
    add_column :get_started_pages, :require_registration_to_unlock_panels, :boolean, default: true
  end
end
