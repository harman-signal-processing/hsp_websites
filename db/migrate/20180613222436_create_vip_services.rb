class CreateVipServices < ActiveRecord::Migration[5.1]
  def change
    create_table :vip_services do |t|
      t.string :name

      t.timestamps
    end
  end
end
