class AddHiddenLocalesToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :hidden_locales, :string
  end
end
