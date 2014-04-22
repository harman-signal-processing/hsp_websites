class SoftwareAttachment < ActiveRecord::Base
  belongs_to :software, touch: true
  has_attached_file :software_attachment, 
    storage: :s3,
    bucket: Rails.configuration.aws[:bucket],
    s3_credentials: Rails.configuration.aws,
    s3_host_alias: S3_CLOUDFRONT,
    url: ':s3_alias_url',
    path: ":class/:attachment/:id_:timestamp/:basename_:style.:extension"
  validates :software_id, presence: true
  validates :name, presence: true
  validates_attachment :software_attachment, presence: true
  do_not_validate_attachment_file_type :software_attachment
end
