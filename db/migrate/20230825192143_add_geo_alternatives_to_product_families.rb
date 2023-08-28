class AddGeoAlternativesToProductFamilies < ActiveRecord::Migration[7.0]
  def change
    add_column :product_families, :geo_parent_id, :integer
    add_index :product_families, :geo_parent_id
  end
end
