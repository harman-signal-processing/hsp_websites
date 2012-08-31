class AddVintageRepair < ActiveRecord::Migration
  def change
  	add_column :service_centers, :vintage, :boolean
  	add_column :brands, :has_vintage_repair, :boolean
  end
end
