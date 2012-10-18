class AddSecretCodeToLabelSheetOrders < ActiveRecord::Migration
  def change
    add_column :label_sheet_orders, :secret_code, :string
  end
end
