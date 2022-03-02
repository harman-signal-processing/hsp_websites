class AddCartIdToCustomShopQuote < ActiveRecord::Migration[6.1]
  def change
    add_column :custom_shop_quotes, :custom_shop_cart_id, :integer
    add_index :custom_shop_quotes, :custom_shop_cart_id
  end
end
