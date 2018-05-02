class RemoveDefaultSubscribeFromWarrantyRegistrations < ActiveRecord::Migration[5.1]
  def up
    change_column_default :warranty_registrations, :subscribe, false
  end

  def down
    change_column_default :warranty_registrations, :subscribe, true
  end
end
