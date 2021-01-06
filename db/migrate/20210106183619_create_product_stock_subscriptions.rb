class CreateProductStockSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :product_stock_subscriptions do |t|
      t.integer :user_id
      t.integer :product_id
      t.integer :low_stock_level

      t.timestamps
    end
    add_index :product_stock_subscriptions, :user_id
    add_index :product_stock_subscriptions, :product_id
  end
end
