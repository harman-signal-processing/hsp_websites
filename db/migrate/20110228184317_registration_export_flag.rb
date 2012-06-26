class RegistrationExportFlag < ActiveRecord::Migration
  def self.up
    add_column :warranty_registrations, :exported, :boolean, :default => false
    add_index :warranty_registrations, :exported
  end

  def self.down
    remove_index :warranty_registrations, :exported
    remove_column :warranty_registrations, :exported
  end
end