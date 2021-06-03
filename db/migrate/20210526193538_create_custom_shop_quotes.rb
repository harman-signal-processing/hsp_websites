class CreateCustomShopQuotes < ActiveRecord::Migration[6.1]
  def change
    create_table :custom_shop_quotes do |t|
      t.string :uuid
      t.integer :user_id
      t.string :account_number
      t.string :opportunity_number
      t.string :opportunity_name
      t.string :location
      t.text :description
      t.date :request_delivery_on

      t.timestamps
    end
    add_index :custom_shop_quotes, :user_id
  end
end
