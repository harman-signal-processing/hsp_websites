class CreateProductSoftwares < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :product_softwares, :options => options do |t|
      t.integer :product_id
      t.integer :software_id

      t.timestamps
    end
  end

  def self.down
    drop_table :product_softwares
  end
end
