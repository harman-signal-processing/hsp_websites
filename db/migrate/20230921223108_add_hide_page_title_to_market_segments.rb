class AddHidePageTitleToMarketSegments < ActiveRecord::Migration[7.0]
  def change
    add_column :market_segments, :hide_page_title, :boolean
  end
end
