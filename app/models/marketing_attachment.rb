class MarketingAttachment < ActiveRecord::Base
  attr_accessible :marketing_file, :marketing_project_id
  belongs_to :marketing_project
  validate :marketing_project_id, presence: true
  has_attached_file :marketing_file,
    storage: :s3,
    s3_credentials: S3_CREDENTIALS,
    bucket: S3_CREDENTIALS['protected_bucket'],
    # s3_host_alias: S3_CLOUDFRONT,
    # url: ':s3_alias_url',
    path: ":class/:attachment/:id_:timestamp/:basename_:style.:extension"
    # path: ":rails_root/public/system/:attachment/:id_:timestamp/:basename_:style.:extension",
    # url: "/system/:attachment/:id_:timestamp/:basename_:style.:extension"
end
