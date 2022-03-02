class CreateCustomShopLineItemAttributes < ActiveRecord::Migration[6.1]
  def change
    create_table :custom_shop_line_item_attributes do |t|
      t.integer :custom_shop_line_item_id
      t.integer :customizable_attribute_id
      t.string :value

      t.timestamps
    end
    #add_index :custom_shop_line_item_attributes, :custom_shop_line_item_id
  end
end
