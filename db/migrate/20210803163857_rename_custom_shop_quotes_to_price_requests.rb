class RenameCustomShopQuotesToPriceRequests < ActiveRecord::Migration[6.1]
  def change
    rename_table :custom_shop_quotes, :custom_shop_price_requests
    remove_index :custom_shop_line_items, name: "index_custom_shop_line_items_on_custom_shop_quote_id"
    rename_column :custom_shop_line_items, :custom_shop_quote_id, :custom_shop_price_request_id
    add_index :custom_shop_line_items, :custom_shop_price_request_id
  end
end
