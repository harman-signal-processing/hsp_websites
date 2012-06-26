class AddProductFamilyHide < ActiveRecord::Migration
  def self.up
    add_column :product_families, :hide_from_homepage, :boolean, :default => false
  end

  def self.down
    remove_column :product_families, :hide_from_homepage
  end
end
