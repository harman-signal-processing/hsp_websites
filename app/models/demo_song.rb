class DemoSong < ActiveRecord::Base
  belongs_to :product_attachment, touch: true
  validates_presence_of :product_attachment_id
  has_attached_file :mp3, 
    storage: :s3,
    bucket: S3_CREDENTIALS['bucket'],
    s3_credentials: S3_CREDENTIALS,
    s3_host_alias: S3_CLOUDFRONT,
    url: ':s3_alias_url',
    path: ":class/:attachment/:id_:timestamp/:basename_:style.:extension"
	validates_attachment :mp3, content_type: { content_type: /\Aaudio/i }
  acts_as_list scope: :product_attachment_id
end
