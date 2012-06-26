class CreateProductFamilyProducts < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :product_family_products, :options => options do |t|
      t.integer :product_id
      t.integer :product_family_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :product_family_products
  end
end
