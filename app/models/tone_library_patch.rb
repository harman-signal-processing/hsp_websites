class ToneLibraryPatch < ActiveRecord::Base
  belongs_to :tone_library_song
  belongs_to :product
  has_attached_file :patch
  validates_presence_of :tone_library_song_id, :product_id
end
