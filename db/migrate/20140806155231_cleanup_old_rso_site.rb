class CleanupOldRsoSite < ActiveRecord::Migration
  def change
    drop_table :rso_monthly_reports
    drop_table :rso_navigations
    drop_table :rso_pages
    drop_table :rso_panels
    drop_table :rso_personal_reports
    drop_table :rso_settings

    remove_column :brands, :rso_enabled
    remove_column :users, :rso_admin
  end
end
