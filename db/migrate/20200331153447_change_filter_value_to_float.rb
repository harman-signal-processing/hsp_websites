class ChangeFilterValueToFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :product_product_filter_values, :number_value, :float
  end
end
