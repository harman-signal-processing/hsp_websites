class AddGainFieldsToDownloadRegistrations < ActiveRecord::Migration
  def self.up
    add_column :download_registrations, :employee_number, :string
    add_column :download_registrations, :store_number, :string
    add_column :download_registrations, :manager_name, :string
  end

  def self.down
    remove_column :download_registrations, :manager_name
    remove_column :download_registrations, :store_number
    remove_column :download_registrations, :employee_number
  end
end
