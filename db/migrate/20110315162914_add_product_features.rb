class AddProductFeatures < ActiveRecord::Migration
  def self.up
    add_column :products, :features, :text
  end

  def self.down
    remove_column :products, :features
  end
end