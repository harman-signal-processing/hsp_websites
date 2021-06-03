class CreateCustomShopQuoteLineItemAttributes < ActiveRecord::Migration[6.1]
  def change
    create_table :custom_shop_quote_line_item_attributes do |t|
      t.integer :line_item_id
      t.integer :customizable_attribute_id
      t.string :value

      t.timestamps
    end
    add_index :custom_shop_quote_line_item_attributes, :line_item_id
  end
end
