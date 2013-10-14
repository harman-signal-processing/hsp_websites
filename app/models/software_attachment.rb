class SoftwareAttachment < ActiveRecord::Base
  belongs_to :software, touch: true
  has_attached_file :software_attachment,
    path: ":rails_root/public/system/:attachment/:id_:timestamp/:basename_:style.:extension",
    url: "/system/:attachment/:id_:timestamp/:basename_:style.:extension"

  validates_presence_of :software_id, :name, :software_attachment
end
