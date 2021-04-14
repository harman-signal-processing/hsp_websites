class AddNoteToAmxDxlinkAttributesNames < ActiveRecord::Migration[6.1]
  def change
    add_column :amx_dxlink_attribute_names, :note, :text
  end
end
