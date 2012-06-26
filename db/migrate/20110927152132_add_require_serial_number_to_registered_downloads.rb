class AddRequireSerialNumberToRegisteredDownloads < ActiveRecord::Migration
  def self.up
    add_column :registered_downloads, :require_serial_number, :boolean
  end

  def self.down
    remove_column :registered_downloads, :require_serial_number
  end
end
