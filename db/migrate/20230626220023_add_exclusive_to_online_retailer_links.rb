class AddExclusiveToOnlineRetailerLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :online_retailer_links, :exclusive, :boolean, default: false
  end
end
