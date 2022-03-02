class CreateAmxDxlinkComboAttributes < ActiveRecord::Migration[6.1]
  def change
    create_table :amx_dxlink_combo_attributes do |t|
      t.string :value
      t.references :amx_dxlink_attribute_name, null: false, foreign_key: true, index: {name:'idx_dxlink_combo_attr_on_attr_name_id'}
      t.references :amx_dxlink_combo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
