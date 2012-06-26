class AddClinicianRolesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :clinician, :boolean
    add_column :users, :rep, :boolean
    add_column :users, :clinic_admin, :boolean
  end

  def self.down
    remove_column :users, :clinic_admin
    remove_column :users, :rep
    remove_column :users, :clinician
  end
end
