class SoftwareAttachment < ActiveRecord::Base
  belongs_to :software
  has_attached_file :software_attachment
  validates_presence_of :software_id, :name, :software_attachment
end
