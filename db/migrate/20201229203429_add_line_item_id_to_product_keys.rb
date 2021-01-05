class AddLineItemIdToProductKeys < ActiveRecord::Migration[6.0]
  def change
    add_column :product_keys, :line_item_id, :integer
    add_index :product_keys, :line_item_id
  end
end
