class AddGainFieldsToRegisteredDownloads < ActiveRecord::Migration
  def self.up
    add_column :registered_downloads, :require_employee_number, :boolean
    add_column :registered_downloads, :require_store_number, :boolean
    add_column :registered_downloads, :require_manager_name, :boolean
    add_column :registered_downloads, :send_coupon_code, :boolean
    add_column :registered_downloads, :coupon_codes, :text
  end

  def self.down
    remove_column :registered_downloads, :coupon_codes
    remove_column :registered_downloads, :send_coupon_code
    remove_column :registered_downloads, :require_manager_name
    remove_column :registered_downloads, :require_store_number
    remove_column :registered_downloads, :require_employee_number
  end
end
