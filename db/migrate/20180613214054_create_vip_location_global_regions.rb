class CreateVipLocationGlobalRegions < ActiveRecord::Migration[5.1]
  def change
    create_table :vip_location_global_regions do |t|
      t.integer :position
      t.references :vip_location, foreign_key: true
      t.references :vip_global_region, foreign_key: true

      t.timestamps
    end
  end
end
