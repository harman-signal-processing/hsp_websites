class CreateManufacturerPartner < ActiveRecord::Migration[5.1]
  def change
    create_table :manufacturer_partners do |t|
      t.string :name
      t.string :url
      t.boolean :amx_device_discovery
    end
  end
end
