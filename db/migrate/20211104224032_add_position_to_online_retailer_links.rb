class AddPositionToOnlineRetailerLinks < ActiveRecord::Migration[6.1]
  def change
    add_column :online_retailer_links, :position, :integer
  end
end
