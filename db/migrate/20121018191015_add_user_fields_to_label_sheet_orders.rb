class AddUserFieldsToLabelSheetOrders < ActiveRecord::Migration
  def change
    add_column :label_sheet_orders, :name, :string
    add_column :label_sheet_orders, :email, :string
    add_column :label_sheet_orders, :address, :string
    add_column :label_sheet_orders, :city, :string
    add_column :label_sheet_orders, :state, :string
    add_column :label_sheet_orders, :postal_code, :string
    add_column :label_sheet_orders, :country, :string
  end
end
