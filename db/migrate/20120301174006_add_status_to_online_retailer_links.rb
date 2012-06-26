class AddStatusToOnlineRetailerLinks < ActiveRecord::Migration
  def change
    add_column :online_retailer_links, :link_status, :string, :default => "200"
    add_column :product_reviews, :link_status, :string, :default => "200"
    add_column :softwares, :link_status, :string, :default => "200"
  end
end
