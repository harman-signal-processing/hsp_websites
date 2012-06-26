class AddSoftwareCategory < ActiveRecord::Migration
  def self.up
    add_column :softwares, :category, :string
  end

  def self.down
    remove_column :softwares, :category
  end
end
