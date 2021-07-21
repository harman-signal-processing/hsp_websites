class AddStatusToCustomShopQuotes < ActiveRecord::Migration[6.1]
  def change
    add_column :custom_shop_quotes, :status, :string
  end
end
