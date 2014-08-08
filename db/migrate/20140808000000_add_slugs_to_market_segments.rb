class AddSlugsToMarketSegments < ActiveRecord::Migration
  def change
    add_column :market_segments, :cached_slug, :string
    add_index :market_segments, :cached_slug

    MarketSegment.all.each{|ms| ms.save}
  end
end
