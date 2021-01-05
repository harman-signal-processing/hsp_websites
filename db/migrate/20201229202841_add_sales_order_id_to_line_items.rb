class AddSalesOrderIdToLineItems < ActiveRecord::Migration[6.0]
  def change
    add_column :line_items, :sales_order_id, :integer
    add_index :line_items, :sales_order_id
  end
end
