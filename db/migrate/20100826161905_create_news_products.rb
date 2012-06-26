class CreateNewsProducts < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :news_products, :options => options do |t|
      t.integer :product_id
      t.integer :news_id

      t.timestamps
    end
  end

  def self.down
    drop_table :news_products
  end
end
