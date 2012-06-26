class AddStreetPriceToProducts < ActiveRecord::Migration
  def change
    add_column :products, :street_price, :float
  end
end
