class AddQueueAdminRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :queue_admin, :boolean
  end
end
