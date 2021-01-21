class AddAddressToSalesOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :sales_orders, :address_id, :integer
  end
end
