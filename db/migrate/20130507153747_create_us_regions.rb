class CreateUsRegions < ActiveRecord::Migration
  def change
    create_table :us_regions do |t|
      t.string :name
      t.string :cached_slug
      t.timestamps
    end
    add_index :us_regions, :cached_slug
  end
end
