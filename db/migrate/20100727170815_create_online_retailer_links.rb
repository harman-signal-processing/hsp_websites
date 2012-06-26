class CreateOnlineRetailerLinks < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :online_retailer_links, :options => options do |t|
      t.integer :product_id
      t.integer :brand_id
      t.integer :online_retailer_id
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :online_retailer_links
  end
end
