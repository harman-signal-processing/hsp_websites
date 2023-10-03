class AddCustomCssJsToMarketSegments < ActiveRecord::Migration[7.0]
  def change
    add_column :market_segments, :custom_css, :text
    add_column :market_segments, :custom_js, :text
  end
end
