class AddBannersToMarketSegments < ActiveRecord::Migration
  def change
    add_attachment :market_segments, :banner_image
  end
end
