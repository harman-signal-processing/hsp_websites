class AddToolkitRolesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dealer, :boolean
    add_column :users, :distributor, :boolean
    add_column :users, :marketing_staff, :boolean
  end
end
