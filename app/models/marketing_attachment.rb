class MarketingAttachment < ActiveRecord::Base
  attr_accessible :marketing_file, :marketing_project_id
  belongs_to :marketing_project
  validate :marketing_project_id, presence: true
  has_attached_file :marketing_file,
    bucket: S3_CREDENTIALS['protected_bucket'],
    s3_host_alias: nil,
    path: ":class/:attachment/:id_:timestamp/:basename_:style.:extension"
end
