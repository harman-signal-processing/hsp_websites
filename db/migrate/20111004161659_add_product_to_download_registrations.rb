class AddProductToDownloadRegistrations < ActiveRecord::Migration
  def self.up
    add_column :download_registrations, :product, :string
  end

  def self.down
    remove_column :download_registrations, :product
  end
end
