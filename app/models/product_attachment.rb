class ProductAttachment < ActiveRecord::Base
  belongs_to :product, touch: true
  has_attached_file :product_attachment, 
    styles: { 
      full_width: "1024x768",
      lightbox: "800x600",
      large: "640x480", 
      medium: "480x360", 
      horiz_medium: "670x275",
      epedal: "400x250",
      vert_medium: "375x400",
      medium_small: "150x225",
      small: "240x180",
      horiz_thumb: "170x80",
      thumb: "100x100", 
      tiny: "64x64", 
      tiny_square: "64x64#",
      soundcomm: "160x160"
    },
    convert_options: {
      soundcomm: "-gravity center -extent 160x160"
    }, 
    storage: :s3,
    bucket: Rails.configuration.aws[:bucket],
    s3_credentials: Rails.configuration.aws,
    s3_host_alias: S3_CLOUDFRONT,
    url: ':s3_alias_url',
    path: ":class/:attachment/:id_:timestamp/:basename_:style.:extension"
  validates_attachment :product_attachment, content_type: { content_type: /\Aimage/i }

  has_attached_file :product_media, 
    storage: :s3,
    bucket: Rails.configuration.aws[:bucket],
    s3_credentials: Rails.configuration.aws,
    s3_host_alias: S3_CLOUDFRONT,
    url: ':s3_alias_url',
    path: ":class/:attachment/:id_:timestamp/:basename_:style.:extension"
  has_attached_file :product_media_thumb, styles: {thumb: "100x100>", tiny: "64x64>"}, 
    storage: :s3,
    bucket: Rails.configuration.aws[:bucket],
    s3_credentials: Rails.configuration.aws,
    s3_host_alias: S3_CLOUDFRONT,
    url: ':s3_alias_url',
    path: ":class/:attachment/:id_:timestamp/:basename_:style.:extension"

  do_not_validate_attachment_file_type :product_media
  validates_attachment :product_media_thumb, content_type: { content_type: /\Aimage/i }

  process_in_background :product_attachment
  process_in_background :product_media

  has_many :demo_songs, order: :position
  accepts_nested_attributes_for :demo_songs, reject_if: :all_blank
  validates :product_id, presence: true
  validates_uniqueness_of :songlist_tag, allow_blank: true
  acts_as_list scope: :product_id
  after_save :update_primary_photo
  after_destroy :remove_as_primary_photo
  
  def update_primary_photo
    if self.product && self.product.photo 
      ProductAttachment.update_all(
        ["primary_photo = ?", false], 
        ["product_id = ? AND id != ?", self.product_id, self.id]
      ) if self.primary_photo
    else
      self.update_attributes(primary_photo: true)
    end
  end
  
  def remove_as_primary_photo
    if self.product && !self.product.photo && self.product.product_attachments.size > 0
      self.product.product_attachments.first.update_attributes(primary_photo: true)
    end
  end
  
  def for_product_page?
    !(self.hide_from_product_page?)
  end

  def for_toolkit?
    true
  end

  def name
    (product_attachment_file_name.present?) ? product_attachment_file_name : product_media_file_name
  end
  
  # Determine if this attachment is a photo...or something else
  def is_photo?
    !self.product_attachment_file_name.blank?
  end
  
end
