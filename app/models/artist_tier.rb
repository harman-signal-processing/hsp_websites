class ArtistTier < ActiveRecord::Base
  has_many :artists
  validates :name, presence: true, uniqueness: true
  validates :invitation_code, uniqueness: true
  acts_as_list

  def self.default
    begin
      where("invitation_code IS NULL or invitation_code = ''").first
    rescue
      first
    end
  end

  def self.for_artist_page
    where(show_on_artist_page: true).order("position")
  end

  def artists_for(website)
    artists.where("approver_id IS NOT NULL AND approver_id != ''").joins(:artist_brands).where("artist_brands.brand_id = ?", website.brand_id).order("UPPER(artists.name)")
  end
end
