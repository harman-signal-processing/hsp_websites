class ArtistBrand < ApplicationRecord
  belongs_to :artist
  belongs_to :brand
  validates :artist_id, uniqueness: { scope: :brand_id, case_sensitive: false }
end
