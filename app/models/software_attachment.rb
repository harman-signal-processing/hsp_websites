class SoftwareAttachment < ApplicationRecord
  belongs_to :software, touch: true
  has_attached_file :software_attachment
  validates :name, presence: true
  validates_attachment :software_attachment, presence: true
  do_not_validate_attachment_file_type :software_attachment
end
