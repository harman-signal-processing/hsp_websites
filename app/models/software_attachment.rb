class SoftwareAttachment < ActiveRecord::Base
  belongs_to :software, touch: true
  has_attached_file :software_attachment,
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"

  validates_presence_of :software_id, :name, :software_attachment
end
