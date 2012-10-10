class AddPreferredToOnlineRetailers < ActiveRecord::Migration
  def change
    add_column :online_retailers, :preferred, :integer
  end
end
