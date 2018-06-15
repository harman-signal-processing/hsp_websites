class CreateVipServiceAreas < ActiveRecord::Migration[5.1]
  def change
    create_table :vip_service_areas do |t|
      t.string :name

      t.timestamps
    end
  end
end
