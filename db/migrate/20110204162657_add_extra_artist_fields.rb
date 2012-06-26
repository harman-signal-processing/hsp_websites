class AddExtraArtistFields < ActiveRecord::Migration
  def self.up
    add_column :artist_products, :quote, :text
    add_column :artist_products, :on_tour, :boolean, :default => false
    add_column :artists, :featured, :boolean, :default => false
    add_column :artists, :summary, :text
  end

  def self.down
    remove_column :artists, :summary
    remove_column :artists, :featured
    remove_column :artist_products, :on_tour
    remove_column :artist_products, :quote
  end
end