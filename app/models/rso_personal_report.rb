class RsoPersonalReport < ActiveRecord::Base
  belongs_to :user
  has_attached_file :rso_personal_report, 
    styles: { 
      large: "960x600", 
      medium: "480x360", 
      small: "240x180",
      thumb: "100x100", 
      tiny: "64x64", 
      tiny_square: "64x64#" 
    },
    storage: :s3,
    s3_credentials: S3_CREDENTIALS,
    bucket: S3_CREDENTIALS['bucket'],
    s3_host_alias: S3_CLOUDFRONT,
    url: ':s3_alias_url',
    path: ":class/:attachment/:id_:timestamp/:basename_:style.:extension"
    # path: ":rails_root/public/system/:attachment/:id_:timestamp/:basename_:style.:extension",
    # url: "/system/:attachment/:id_:timestamp/:basename_:style.:extension"

end
