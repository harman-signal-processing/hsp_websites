class AddRepToClinics < ActiveRecord::Migration
  def self.up
    add_column :clinics, :rep_id, :integer
  end

  def self.down
    remove_column :clinics, :rep_id
  end
end
