class DemoSong < ActiveRecord::Base
  belongs_to :product_attachment, touch: true
  validates_presence_of :product_attachment_id
  has_attached_file :mp3,
    path: ":rails_root/public/system/:attachment/:id_:timestamp/:basename_:style.:extension",
    url: ":asset_host/system/:attachment/:id_:timestamp/:basename_:style.:extension"

  acts_as_list scope: :product_attachment_id
end
