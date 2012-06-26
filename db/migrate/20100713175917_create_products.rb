class CreateProducts < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :products, :options => options do |t|
      t.string :name
      t.string :sap_sku
      t.text :description
      t.text :short_description
      t.text :keywords
      t.integer :product_status_id
      t.boolean :rohs, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
