class ToneLibraryPatch < ActiveRecord::Base
  belongs_to :tone_library_song
  belongs_to :product
  has_attached_file :patch,
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"

  validates_presence_of :tone_library_song_id, :product_id
end
