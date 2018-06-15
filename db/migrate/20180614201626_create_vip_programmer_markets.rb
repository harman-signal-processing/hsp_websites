class CreateVipProgrammerMarkets < ActiveRecord::Migration[5.1]
  def change
    create_table :vip_programmer_markets do |t|
      t.integer :position
      t.references :vip_programmer, foreign_key: true
      t.references :vip_market, foreign_key: true

      t.timestamps
    end
  end
end
