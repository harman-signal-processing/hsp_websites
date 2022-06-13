class DropTableLabelSheets < ActiveRecord::Migration[6.1]
  def change
    drop_table :label_sheets
    drop_table :label_sheet_orders
    remove_column :brands, :has_label_sheets
  end
end
