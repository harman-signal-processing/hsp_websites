class ToneLibrarySong < ApplicationRecord
  extend FriendlyId
  friendly_id :title

  has_many :tone_library_patches
  validates :artist_name, presence: true
  validates :title, presence: true

  def displayname
    "#{self.artist_name} -- #{self.title}"
  end

end
