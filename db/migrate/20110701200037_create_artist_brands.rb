class CreateArtistBrands < ActiveRecord::Migration
  def self.up
    create_table :artist_brands do |t|
      t.integer :artist_id
      t.integer :brand_id

      t.timestamps
    end
    Artist.all.each do |artist|
      ArtistBrand.create!(:artist_id => artist.id, :brand_id => 1)
    end
  end

  def self.down
    drop_table :artist_brands
  end
end
