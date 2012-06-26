class ToneLibrarySong < ActiveRecord::Base
  has_many :tone_library_patches
  validates_presence_of :artist_name, :title
  has_friendly_id :title, :use_slug => true, :approximate_ascii => true, :max_length => 100
  
  def displayname
    "#{self.artist_name} -- #{self.title}"
  end
  
end
