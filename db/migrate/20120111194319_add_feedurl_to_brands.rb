class AddFeedurlToBrands < ActiveRecord::Migration
  def self.up
    add_column :brands, :news_feed_url, :string
  end

  def self.down
    remove_column :brands, :news_feed_url
  end
end
