class AddSubscribeToLabelSheetOrders < ActiveRecord::Migration
  def change
    add_column :label_sheet_orders, :subscribe, :boolean
  end
end
