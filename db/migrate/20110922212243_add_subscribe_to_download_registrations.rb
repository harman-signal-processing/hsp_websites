class AddSubscribeToDownloadRegistrations < ActiveRecord::Migration
  def self.up
    add_column :download_registrations, :subscribe, :boolean
  end

  def self.down
    remove_column :download_registrations, :subscribe
  end
end
