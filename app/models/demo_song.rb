class DemoSong < ActiveRecord::Base
  belongs_to :product_attachment, touch: true
  validates_presence_of :product_attachment_id
  has_attached_file :mp3
  acts_as_list scope: :product_attachment_id
end
