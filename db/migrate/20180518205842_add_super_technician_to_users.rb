class AddSuperTechnicianToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :super_technician, :boolean, default: false
  end
end
