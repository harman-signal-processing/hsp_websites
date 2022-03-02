class CreateCustomShopCarts < ActiveRecord::Migration[6.1]
  def change
    create_table :custom_shop_carts do |t|
      t.string :uuid

      t.timestamps
    end
    add_index :custom_shop_carts, :uuid
  end
end
