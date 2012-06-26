class AddEndAtToClinics < ActiveRecord::Migration
  def self.up
    add_column :clinics, :end_at, :datetime
  end

  def self.down
    remove_column :clinics, :end_at
  end
end
