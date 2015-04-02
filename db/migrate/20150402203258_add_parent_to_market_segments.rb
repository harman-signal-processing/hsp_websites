class AddParentToMarketSegments < ActiveRecord::Migration
  def change
    add_column :market_segments, :parent_id, :integer
    add_column :market_segments, :position, :integer
    add_column :market_segments, :description, :text
  end
end
