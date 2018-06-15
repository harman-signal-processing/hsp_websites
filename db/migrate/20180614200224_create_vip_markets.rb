class CreateVipMarkets < ActiveRecord::Migration[5.1]
  def change
    create_table :vip_markets do |t|
      t.string :name

      t.timestamps
    end
  end
end
