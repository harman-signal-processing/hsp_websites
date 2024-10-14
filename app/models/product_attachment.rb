class ProductAttachment < ApplicationRecord
  belongs_to :product, touch: true

  has_attached_file :product_attachment, {
    styles: {
      x_large: ["2048x1536", :webp],
      x_large_2x: ["4096x3072", :webp],
      full_width: ["1024x768", :webp],
      lightbox: ["800x600", :webp],
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
    processors: [:thumbnail, :compression] ,
    convert_options: {
      soundcomm: "-gravity center -extent 160x160"
    }
  }
  validates_attachment :product_attachment, content_type: { content_type: /\Aimage/i }

  has_attached_file :product_media
  has_attached_file :product_media_thumb,
    styles: {
      thumb: "100x100>",
      tiny: "64x64>"
    }

  do_not_validate_attachment_file_type :product_media
  validates_attachment :product_media_thumb, content_type: { content_type: /\Aimage/i }

  process_in_background :product_attachment
  process_in_background :product_media

  acts_as_list scope: :product_id
  before_save :hide_banner_from_carousel
  after_save :update_primary_photo
  after_destroy :remove_as_primary_photo

  def update_primary_photo
    if self.product && self.product.photo
      if self.primary_photo
        ProductAttachment.where(product_id: self.product_id).where.not(id: self.id).update_all(primary_photo: false)
      end
    else
      self.update_column(:primary_photo, true)
    end
  end

  def remove_as_primary_photo
    if self.product && !self.product.photo && self.product.product_attachments.size > 0
      self.product.product_attachments.first.update(primary_photo: true)
    end
  end

  def hide_banner_from_carousel
    if show_as_full_width_banner?
      self.hide_from_product_page = true
    end
  end

  def for_product_page?
    !(self.hide_from_product_page?)
  end

  def name
    (product_attachment_file_name.present?) ? product_attachment_file_name : product_media_file_name
  end

  # Determine if this attachment is a photo...or something else
  def is_photo?
    !self.product_attachment_file_name.blank?
  end

end
