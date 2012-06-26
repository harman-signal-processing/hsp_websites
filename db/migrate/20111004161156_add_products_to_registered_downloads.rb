class AddProductsToRegisteredDownloads < ActiveRecord::Migration
  def self.up
    add_column :registered_downloads, :products, :text
  end

  def self.down
    remove_column :registered_downloads, :products
  end
end
