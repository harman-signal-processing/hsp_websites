class CreateAmxDxlinkAttributeNames < ActiveRecord::Migration[6.1]
  def change
    create_table :amx_dxlink_attribute_names do |t|
      t.string :name
      t.integer :position
      t.timestamps
    end
  end
end
