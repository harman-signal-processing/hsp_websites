class AddVipProgrammersAdminRoleToUsers < ActiveRecord::Migration[5.1]
  def self.up
    add_column :users, :vip_programmers_admin, :boolean, default: false
  end

  def self.down
    remove_column :users, :vip_programmers_admin
  end
end
