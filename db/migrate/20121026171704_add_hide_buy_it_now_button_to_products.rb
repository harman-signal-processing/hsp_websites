class AddHideBuyItNowButtonToProducts < ActiveRecord::Migration
  def change
    add_column :products, :hide_buy_it_now_button, :boolean
  end
end
