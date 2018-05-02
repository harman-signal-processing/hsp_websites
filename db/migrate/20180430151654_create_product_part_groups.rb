class CreateProductPartGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :product_part_groups do |t|
      t.integer :product_id
      t.string :name
      t.integer :parent_id

      t.timestamps
    end
    add_index :product_part_groups, :product_id
    add_index :product_part_groups, :parent_id
  end
end
