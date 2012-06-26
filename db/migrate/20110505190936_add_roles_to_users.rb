class AddRolesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :boolean
    add_column :users, :customer_service, :boolean
    add_column :users, :online_retailer, :boolean
    add_column :users, :translator, :boolean
    add_column :users, :rohs, :boolean
    add_column :users, :market_manager, :boolean
    add_column :users, :artist_relations, :boolean
    add_column :users, :engineer, :boolean
  end

  def self.down
    remove_column :users, :engineer
    remove_column :users, :artist_relations
    remove_column :users, :market_manager
    remove_column :users, :rohs
    remove_column :users, :translator
    remove_column :users, :dealer
    remove_column :users, :online_retailer
    remove_column :users, :customer_service
  end
end