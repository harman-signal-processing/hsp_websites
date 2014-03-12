class AddSyncedOnToWarrantyRegistrations < ActiveRecord::Migration
  def change
    add_column :warranty_registrations, :synced_on, :datetime
  end
end
