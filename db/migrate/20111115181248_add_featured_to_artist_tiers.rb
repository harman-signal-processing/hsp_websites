class AddFeaturedToArtistTiers < ActiveRecord::Migration
  def self.up
    add_column :artist_tiers, :show_on_artist_page, :boolean
    add_column :artist_tiers, :position, :integer
  end

  def self.down
    remove_column :artist_tiers, :position
    remove_column :artist_tiers, :show_on_artist_page
  end
end
