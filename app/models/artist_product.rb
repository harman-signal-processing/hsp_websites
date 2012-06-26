class ArtistProduct < ActiveRecord::Base
  belongs_to :artist, :inverse_of => :artist_products
  belongs_to :product, :inverse_of => :artist_products
  validates :artist, :product, :presence => true
  validates :artist_id, :uniqueness => { :scope => :product_id }
  after_save :link_artist_to_brand
  
  def link_artist_to_brand
    begin
      ArtistBrand.find_or_create_by_artist_id_and_brand_id(self.artist_id, self.product.brand_id)
    rescue
      logger.info "did not link artist with product's brand, no biggie"
    end
  end
  
end
