class CreateLabelSheetOrders < ActiveRecord::Migration
  def change
    create_table :label_sheet_orders do |t|
      t.integer :user_id
      t.text :label_sheets
      t.date :mailed_on

      t.timestamps
    end
  end
end
