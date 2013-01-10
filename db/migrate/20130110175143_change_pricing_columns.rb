class ChangePricingColumns < ActiveRecord::Migration
  def up
  	rename_column :product_prices, :price_cents_cents, :price_cents
  	rename_column :product_prices, :price_cents_currency, :price_currency
  end

  def down
  	rename_column :product_prices, :price_cents, :price_cents_cents
  	rename_column :product_prices, :price_currency, :price_cents_currency
  end
end
