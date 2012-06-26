class AddCountryNameToDistributors < ActiveRecord::Migration
  def self.up
    add_column :distributors, :country, :string
    remove_column :distributors, :country_id
  end

  def self.down
    remove_column :distributors, :country
    add_column :distributors, :country_id, :integer
  end
end
