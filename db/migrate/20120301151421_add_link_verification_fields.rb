class AddLinkVerificationFields < ActiveRecord::Migration
  def up
    add_column :online_retailer_links, :link_checked_at, :datetime
    add_column :product_reviews, :link_checked_at, :datetime
    add_column :softwares, :link_checked_at, :datetime
  end

  def down
    remove_column :softwares, :link_checked_at
    remove_column :product_reviews, :link_checked_at
    remove_column :online_retailer_links, :link_checked_at
  end
end