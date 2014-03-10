class AddSyncedOnToSignups < ActiveRecord::Migration
  def change
    add_column :signups, :synced_on, :date
  end
end
