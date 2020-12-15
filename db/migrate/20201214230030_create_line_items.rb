class CreateLineItems < ActiveRecord::Migration[6.0]
  def change
    create_table :line_items do |t|
      t.integer :product_id
      t.integer :shopping_cart_id
      t.integer :quantity
      t.integer :price_cents

      t.timestamps
    end
    add_index :line_items, :product_id
    add_index :line_items, :shopping_cart_id
  end
end
