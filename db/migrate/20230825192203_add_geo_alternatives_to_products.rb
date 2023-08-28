class AddGeoAlternativesToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :geo_parent_id, :integer
    add_index :products, :geo_parent_id
  end
end
