class AddSalesAdminRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sales_admin, :boolean
  end
end
