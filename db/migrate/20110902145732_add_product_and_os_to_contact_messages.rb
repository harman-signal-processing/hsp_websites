class AddProductAndOsToContactMessages < ActiveRecord::Migration
  def self.up
    add_column :contact_messages, :product, :string
    add_column :contact_messages, :operating_system, :string
  end

  def self.down
    remove_column :contact_messages, :operating_system
    remove_column :contact_messages, :product
  end
end
