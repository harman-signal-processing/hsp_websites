class CreateProductKeys < ActiveRecord::Migration[6.0]
  def change
    create_table :product_keys do |t|
      t.string :key
      t.string :email
      t.integer :user_id
      t.integer :sales_order_id
      t.integer :product_id

      t.timestamps
    end
    add_index :product_keys, :user_id
    add_index :product_keys, :sales_order_id
    add_index :product_keys, :product_id
  end
end
