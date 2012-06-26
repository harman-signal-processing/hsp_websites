class AddProtectionToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :password, :string
    add_column :pages, :username, :string
  end

  def self.down
    remove_column :pages, :username
    remove_column :pages, :password
  end
end