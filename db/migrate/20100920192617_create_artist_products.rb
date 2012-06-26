class CreateArtistProducts < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :artist_products, :options => options do |t|
      t.integer :artist_id
      t.integer :product_id

      t.timestamps
    end
  end

  def self.down
    drop_table :artist_products
  end
end
