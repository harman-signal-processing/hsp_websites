class CreateVipLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :vip_locations do |t|
      t.string :name
      t.string :city
      t.string :state
      t.string :country

      t.timestamps
    end
  end
end
