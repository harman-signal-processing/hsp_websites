class AddWebsiteIdToAdminLog < ActiveRecord::Migration
  def change
    add_column :admin_logs, :website_id, :integer
  end
end
