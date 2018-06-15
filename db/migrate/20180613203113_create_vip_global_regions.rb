class CreateVipGlobalRegions < ActiveRecord::Migration[5.1]
  def change
    create_table :vip_global_regions do |t|
      t.string :name

      t.timestamps
    end
  end
end
