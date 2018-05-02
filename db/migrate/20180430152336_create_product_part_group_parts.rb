class CreateProductPartGroupParts < ActiveRecord::Migration[5.1]
  def change
    create_table :product_part_group_parts do |t|
      t.integer :product_part_group_id
      t.integer :part_id

      t.timestamps
    end
    add_index :product_part_group_parts, :product_part_group_id
    add_index :product_part_group_parts, :part_id
  end
end
