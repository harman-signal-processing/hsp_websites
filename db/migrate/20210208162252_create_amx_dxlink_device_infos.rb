class CreateAmxDxlinkDeviceInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :amx_dxlink_device_infos do |t|
      t.string :model
      t.string :model_family
      t.string :type_long_name
      t.string :type_short_name
      t.string :product_url
      t.string :image_url

      t.timestamps
    end
  end
end
