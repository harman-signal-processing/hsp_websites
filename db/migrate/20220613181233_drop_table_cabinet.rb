class DropTableCabinet < ActiveRecord::Migration[6.1]
  def change
    drop_table :cabinets
    drop_table :product_cabinets
  end
end
