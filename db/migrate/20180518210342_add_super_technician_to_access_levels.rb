class AddSuperTechnicianToAccessLevels < ActiveRecord::Migration[5.1]
  def change
    add_column :access_levels, :super_technician, :boolean, default: false
  end
end
