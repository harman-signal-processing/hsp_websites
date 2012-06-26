class AddDetailedProductDescription < ActiveRecord::Migration
  def self.up
    add_column :products, :extended_description, :text
  end

  def self.down
    remove_column :proudcts, :extended_description
  end
end
