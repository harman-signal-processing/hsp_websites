class CreateMarketSegments < ActiveRecord::Migration
  def self.up
    create_table :market_segments do |t|
      t.string :name
      t.integer :brand_id
      t.timestamps
    end
  end

  def self.down
    drop_table :market_segments
  end
end
