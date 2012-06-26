class CreateProductCabinets < ActiveRecord::Migration
  def self.up
    create_table :product_cabinets do |t|
      t.integer :product_id
      t.integer :cabinet_id

      t.timestamps
    end
  end

  def self.down
    drop_table :product_cabinets
  end
end
