class AddAutoDeliverToRegisteredDownloads < ActiveRecord::Migration
  def change
    add_column :registered_downloads, :auto_deliver, :boolean
  end
end
