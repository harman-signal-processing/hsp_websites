class AddCustomShopAdminRoleToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :custom_shop_admin, :boolean, default: false
  end
end
