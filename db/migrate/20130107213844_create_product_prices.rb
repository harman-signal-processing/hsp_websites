class CreateProductPrices < ActiveRecord::Migration
  def change
    create_table :product_prices do |t|
      t.integer :product_id
      t.integer :pricing_type_id
      t.money :price_cents

      t.timestamps
    end
    add_index :product_prices, :product_id
    add_index :product_prices, :pricing_type_id
  end
end
