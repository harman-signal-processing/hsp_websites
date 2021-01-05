class AddDetailsToShoppingCart < ActiveRecord::Migration[6.0]
  def change
    add_column :shopping_carts, :uuid, :string
    add_index :shopping_carts, :uuid
    add_column :shopping_carts, :payment_data, :text
  end
end
