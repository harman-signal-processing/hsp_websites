class CreateAmxDxlinkCombos < ActiveRecord::Migration[6.1]
  def change
    create_table :amx_dxlink_combos do |t|
      t.boolean :recommended
      t.text :notes
      t.references :tx, null: false
      t.references :rx, null: false

      t.timestamps
    end
    
    add_foreign_key :amx_dxlink_combos, :amx_dxlink_device_infos, column: :tx_id, primary_key: :id
    add_foreign_key :amx_dxlink_combos, :amx_dxlink_device_infos, column: :rx_id, primary_key: :id
    
  end
end
