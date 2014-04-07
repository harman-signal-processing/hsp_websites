class AddContentTypeToOnlineRetailers < ActiveRecord::Migration
  def up
  	rename_column :online_retailers, :retailer_logo_file_type, :retailer_logo_content_type
  end

  def down
  	rename_column :online_retailers, :retailer_logo_content_type, :retailer_logo_file_type
  end
end
