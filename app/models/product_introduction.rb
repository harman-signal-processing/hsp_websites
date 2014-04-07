class ProductIntroduction < ActiveRecord::Base
  belongs_to :product
  attr_accessible :content, :expires_on, :extra_css, :layout_class, :product_id, :top_image, :box_bg_image, :page_bg_image
  validates :product_id, presence: true
  has_attached_file :top_image, 
    storage: :s3,
    bucket: S3_CREDENTIALS['bucket'],
    s3_credentials: S3_CREDENTIALS,
    s3_host_alias: S3_CLOUDFRONT,
    url: ':s3_alias_url',
    path: ":class/:attachment/:id_:timestamp/:basename_:style.:extension"
  has_attached_file :box_bg_image, 
    storage: :s3,
    bucket: S3_CREDENTIALS['bucket'],
    s3_credentials: S3_CREDENTIALS,
    s3_host_alias: S3_CLOUDFRONT,
    url: ':s3_alias_url',
    path: ":class/:attachment/:id_:timestamp/:basename_:style.:extension"
  has_attached_file :page_bg_image, 
    storage: :s3,
    bucket: S3_CREDENTIALS['bucket'],
    s3_credentials: S3_CREDENTIALS,
    s3_host_alias: S3_CLOUDFRONT,
    url: ':s3_alias_url',
    path: ":class/:attachment/:id_:timestamp/:basename_:style.:extension"

  validates_attachment :top_image, content_type: { content_type: /\Aimage/i }
  validates_attachment :box_bg_image, content_type: { content_type: /\Aimage/i }
  validates_attachment :page_bg_image, content_type: { content_type: /\Aimage/i }

  def expired?
  	self.expires_on ||= 1.week.from_now
  	!!(self.expires_on.to_date <= Date.today)
  end
end
