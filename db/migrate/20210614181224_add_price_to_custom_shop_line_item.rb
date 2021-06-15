class AddPriceToCustomShopLineItem < ActiveRecord::Migration[6.1]
  def change
    add_column :custom_shop_line_items, :price_cents, :integer
  end
end
