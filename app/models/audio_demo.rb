class AudioDemo < ActiveRecord::Base
  has_many :product_audio_demos, dependent: :destroy
  has_many :products, through: :product_audio_demos
  validates :name, presence: true
  has_attached_file :dry_demo,
    storage: :s3,
    s3_credentials: S3_CREDENTIALS,
    bucket: S3_CREDENTIALS['bucket'],
    s3_host_alias: S3_CLOUDFRONT,
    url: ':s3_alias_url',
    path: ":class/:attachment/:id_:timestamp/:basename_:style.:extension"
    # path: ":rails_root/public/system/:attachment/:id_:timestamp/:basename_:style.:extension",
    # url: "/system/:attachment/:id_:timestamp/:basename_:style.:extension"

  has_attached_file :wet_demo,
    storage: :s3,
    s3_credentials: S3_CREDENTIALS,
    bucket: S3_CREDENTIALS['bucket'],
    s3_host_alias: S3_CLOUDFRONT,
    url: ':s3_alias_url',
    path: ":class/:attachment/:id_:timestamp/:basename_:style.:extension"
    # path: ":rails_root/public/system/:attachment/:id_:timestamp/:basename_:style.:extension",
    # url: "/system/:attachment/:id_:timestamp/:basename_:style.:extension"

end
