class AddPricesToProducts < ActiveRecord::Migration
  def change
    add_column :products, :sale_price, :float

    add_column :products, :msrp, :float

  end
end
