class AddCustomValueToCustomShopLineItemAttributes < ActiveRecord::Migration[6.1]
  def change
    add_column :custom_shop_line_item_attributes, :custom_value, :string
  end
end
