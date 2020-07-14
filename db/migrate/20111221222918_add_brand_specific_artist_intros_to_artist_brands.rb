class AddBrandSpecificArtistIntrosToArtistBrands < ActiveRecord::Migration
  def self.up
    add_column :artist_brands, :intro, :text
    ArtistBrand.all.each do |ab|
      ab.update(:intro => ab.artist.summary)
    end
    remove_column :artists, :summary
  end

  def self.down
    add_column :artists, :summary, :text
    ArtistBrand.all.each do |ab|
      ab.artist.update(:summary => ab.intro)
    end
    remove_column :artist_brands, :intro
  end
end
