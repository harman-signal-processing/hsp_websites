class DemoSong < ActiveRecord::Base
  belongs_to :product_attachment, touch: true
  validates_presence_of :product_attachment_id
  has_attached_file :mp3
	validates_attachment :mp3, content_type: { content_type: /\Aaudio/i }
  acts_as_list scope: :product_attachment_id
end
