class AddMultipliersToSoftwares < ActiveRecord::Migration
  def self.up
    add_column :softwares, :multipliers, :text
    add_column :softwares, :activation_name, :string
  end

  def self.down
    remove_column :softwares, :activation_name
    remove_column :softwares, :multipliers
  end
end
