class CreateSalesRegionCountries < ActiveRecord::Migration[5.1]
  def change
    create_table :sales_region_countries do |t|
      t.string :name
      t.integer :sales_region_id

      t.timestamps
    end
    add_index :sales_region_countries, :sales_region_id
  end
end
