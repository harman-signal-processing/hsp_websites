class AddRsoRolesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :rso, :boolean
    add_column :users, :rso_admin, :boolean
  end

  def self.down
    remove_column :users, :rso_admin
    remove_column :users, :rso
  end
end
