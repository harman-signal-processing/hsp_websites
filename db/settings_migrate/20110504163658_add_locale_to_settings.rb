class AddLocaleToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :locale, :string
  end

  def self.down
    remove_column :settings, :locale
  end
end