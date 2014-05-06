class AddExecutiveRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :executive, :boolean
  end
end
