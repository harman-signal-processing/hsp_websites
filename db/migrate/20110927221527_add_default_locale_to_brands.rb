class AddDefaultLocaleToBrands < ActiveRecord::Migration
  def self.up
    add_column :brands, :default_locale, :string
  end

  def self.down
    remove_column :brands, :default_locale
  end
end
