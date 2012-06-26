class AddTotalWagesToClinics < ActiveRecord::Migration
  def self.up
    add_column :clinics, :total_wages, :float
  end

  def self.down
    remove_column :clinics, :total_wages
  end
end
