class ArtistBrand < ActiveRecord::Base
  belongs_to :artist
  belongs_to :brand
  validates_presence_of :artist_id, :brand_id
  validates_uniqueness_of :artist_id, scope: :brand_id
end
