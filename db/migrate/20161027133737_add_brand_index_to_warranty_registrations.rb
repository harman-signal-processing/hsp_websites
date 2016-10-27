class AddBrandIndexToWarrantyRegistrations < ActiveRecord::Migration
  def change
    add_index :warranty_registrations, [:brand_id]
    add_index :get_started_pages, [:brand_id]
    add_index :market_segments, [:brand_id]
    add_index :promotions, [:brand_id]
    add_index :registered_downloads, [:brand_id]
    add_index :service_centers, [:brand_id]
    add_index :signups, [:brand_id]
    add_index :site_elements, [:brand_id]
    add_index :softwares, [:brand_id]
    add_index :training_classes, [:brand_id]
    add_index :training_modules, [:brand_id]
    add_index :us_rep_regions, [:brand_id]
    add_index :us_rep_regions, [:brand_id, :us_region_id]
  end
end
