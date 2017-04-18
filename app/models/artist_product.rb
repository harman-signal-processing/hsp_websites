class ArtistProduct < ApplicationRecord
  belongs_to :artist, inverse_of: :artist_products
  belongs_to :product, inverse_of: :artist_products
  validates :artist, :product, presence: true
  validates :artist_id, uniqueness: { scope: :product_id }
  after_save :link_artist_to_brand

  def link_artist_to_brand
    begin
      ArtistBrand.where(artist_id: self.artist_id, brand_id: self.product.brand_id).first_or_create
    rescue
      logger.info "did not link artist with product's brand, no biggie"
    end
  end

end
