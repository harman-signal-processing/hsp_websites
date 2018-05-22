class SiteElementAttachment < ApplicationRecord
  belongs_to :site_element
  has_attached_file :attachment

  validates :site_element, presence: true
  do_not_validate_attachment_file_type :attachment
end
