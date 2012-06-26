class AddLayoutClassAndDirectBuyToProducts < ActiveRecord::Migration
  def change
    add_column :products, :layout_class, :string

    add_column :products, :direct_buy_link, :string

  end
end
