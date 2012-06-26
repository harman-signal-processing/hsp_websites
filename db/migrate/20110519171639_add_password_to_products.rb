class AddPasswordToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :password, :string
    add_column :products, :previewers, :text
  end

  def self.down
    remove_column :products, :previewers
    remove_column :products, :password
  end
end