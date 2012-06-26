class AddDefaultLocaleToWebsites < ActiveRecord::Migration
  def self.up
    add_column :websites, :default_locale, :string
  end

  def self.down
    remove_column :websites, :default_locale
  end
end
