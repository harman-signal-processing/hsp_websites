class AddParentToProductParts < ActiveRecord::Migration[5.1]
  def change
    add_column :product_parts, :parent_part_id, :integer
    add_index :product_parts, :parent_part_id
  end
end
