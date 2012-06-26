class AddFavoritesToArtistProducts < ActiveRecord::Migration
  def self.up
    add_column :artist_products, :favorite, :boolean
  end

  def self.down
    remove_column :artist_products, :favorite
  end
end
