class AddProductHasPedals < ActiveRecord::Migration
  def self.up
    add_column :products, :has_pedals, :boolean, :default => false
  end

  def self.down
    remove_column :products, :has_pedals
  end
end