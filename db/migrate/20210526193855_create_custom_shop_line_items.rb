class CreateCustomShopLineItems < ActiveRecord::Migration[6.1]
  def change
    create_table :custom_shop_line_items do |t|
      t.integer :custom_shop_quote_id
      t.integer :custom_shop_cart_id
      t.integer :product_id
      t.integer :quantity

      t.timestamps
    end
    add_index :custom_shop_line_items, :custom_shop_quote_id
    add_index :custom_shop_line_items, :custom_shop_cart_id
  end
end
