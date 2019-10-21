class CreateProductAccessories < ActiveRecord::Migration[5.2]
  def change
    create_table :product_accessories do |t|
      t.integer :product_id
      t.integer :accessory_product_id

      t.timestamps
    end
    add_index :product_accessories, :product_id
    add_index :product_accessories, :accessory_product_id
  end
end
