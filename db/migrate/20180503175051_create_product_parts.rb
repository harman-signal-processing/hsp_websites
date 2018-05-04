class CreateProductParts < ActiveRecord::Migration[5.1]
  def change
    create_table :product_parts do |t|
      t.integer :product_id
      t.integer :part_id

      t.timestamps
    end
    add_index :product_parts, :product_id
    add_index :product_parts, :part_id
  end
end
