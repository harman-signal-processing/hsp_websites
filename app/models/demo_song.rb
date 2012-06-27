class DemoSong < ActiveRecord::Base
  belongs_to :product_attachment
  validates_presence_of :product_attachment_id
  has_attached_file :mp3,
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"

  acts_as_list :scope => :product_attachment_id
end
