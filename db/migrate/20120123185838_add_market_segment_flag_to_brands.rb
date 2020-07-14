class AddMarketSegmentFlagToBrands < ActiveRecord::Migration
  def self.up
    add_column :brands, :has_market_segments, :boolean
    Brand.all.each do |brand|
      brand.update(:has_market_segments => !!(brand.name.match(/dbx|BSS/i)))
    end
  end

  def self.down
    remove_column :brands, :has_market_segments
  end
end
