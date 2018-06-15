class CreateVipLocationServiceAreas < ActiveRecord::Migration[5.1]
  def change
    create_table :vip_location_service_areas do |t|
      t.integer :position
      t.references :vip_location, foreign_key: true
      t.references :vip_service_area, foreign_key: true

      t.timestamps
    end
  end
end
