class AddEmployeePriceToProducts < ActiveRecord::Migration
  def change
    add_column :products, :harman_employee_price, :float
  end
end
