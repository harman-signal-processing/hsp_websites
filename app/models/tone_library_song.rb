class ToneLibrarySong < ActiveRecord::Base
  has_many :tone_library_patches
  validates_presence_of :artist_name, :title
  extend FriendlyId
  friendly_id :title
  
  def displayname
    "#{self.artist_name} -- #{self.title}"
  end
  
end
