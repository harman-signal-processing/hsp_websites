class ArtistBrand < ApplicationRecord
  belongs_to :artist
  belongs_to :brand
  validates :artist_id, presence: true, uniqueness: { scope: :brand_id }
  validates :brand_id, presence: true
end
