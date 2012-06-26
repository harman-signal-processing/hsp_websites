class AddDefaultWebsiteToBrands < ActiveRecord::Migration
  def self.up
    add_column :brands, :default_website_id, :integer
  end

  def self.down
    remove_column :brands, :default_website_id
  end
end
