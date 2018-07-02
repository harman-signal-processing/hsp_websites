class AddTreeToProductParts < ActiveRecord::Migration[5.1]
  def change
    add_column :product_parts, :parent_id, :integer
    add_index :product_parts, :parent_id
  end
end
