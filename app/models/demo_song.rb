class DemoSong < ActiveRecord::Base
  belongs_to :product_attachment, touch: true
  validates_presence_of :product_attachment_id
  has_attached_file :mp3,
  	storage: :filesystem,
    url: '/:class/:attachment/:id_:timestamp/:basename_:style.:extension',
    path: ":rails_root/public/:class/:attachment/:id_:timestamp/:basename_:style.:extension"
  acts_as_list scope: :product_attachment_id
end
