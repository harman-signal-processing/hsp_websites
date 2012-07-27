class AddDirectLinkToOnlineRetailers < ActiveRecord::Migration
  def change
    add_column :online_retailers, :direct_link, :string
  end
end
