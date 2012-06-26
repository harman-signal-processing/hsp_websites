class CreateMarketSegmentProductFamilies < ActiveRecord::Migration
  def self.up
    create_table :market_segment_product_families do |t|
      t.integer :market_segment_id
      t.integer :product_family_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :market_segment_product_families
  end
end
