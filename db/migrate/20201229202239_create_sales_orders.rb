class CreateSalesOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :sales_orders do |t|
      t.integer :user_id
      t.integer :shopping_cart_id

      t.timestamps
    end
    add_index :sales_orders, :user_id
  end
end
