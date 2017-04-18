class SoftwareAttachment < ApplicationRecord
  belongs_to :software, touch: true
  has_attached_file :software_attachment, S3_STORAGE
  validates :software_id, presence: true
  validates :name, presence: true
  validates_attachment :software_attachment, presence: true
  do_not_validate_attachment_file_type :software_attachment
end
