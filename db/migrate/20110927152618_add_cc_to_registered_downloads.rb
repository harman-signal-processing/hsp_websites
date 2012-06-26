class AddCcToRegisteredDownloads < ActiveRecord::Migration
  def self.up
    add_column :registered_downloads, :cc, :string
  end

  def self.down
    remove_column :registered_downloads, :cc
  end
end
