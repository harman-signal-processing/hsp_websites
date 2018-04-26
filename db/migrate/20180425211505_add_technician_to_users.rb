class AddTechnicianToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :technician, :boolean
  end
end
