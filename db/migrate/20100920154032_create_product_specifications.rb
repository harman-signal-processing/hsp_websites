class CreateProductSpecifications < ActiveRecord::Migration
  def self.up
  options = (Rails.env == "production") ? "ENGINE=INNODB" : "Engine=InnoDB"
    create_table :product_specifications, :options => options do |t|
      t.integer :product_id
      t.integer :specification_id
      t.string :value
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :product_specifications
  end
end
