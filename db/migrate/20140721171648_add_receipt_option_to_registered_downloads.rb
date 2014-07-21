class AddReceiptOptionToRegisteredDownloads < ActiveRecord::Migration
  def change
    add_column :registered_downloads, :require_receipt, :boolean
  end
end
