class ProductReview < ApplicationRecord
  extend FriendlyId
  friendly_id :sanitized_title

  has_attached_file :review
  do_not_validate_attachment_file_type :review

  has_attached_file :cover_image,
    styles: { lightbox: "800x600",
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
      tiny_square: "64x64#"
    }
  validates_attachment :cover_image, content_type: { content_type: /\Aimage/i }

  validates :title, presence: true

  has_many :product_review_products, dependent: :destroy
  has_many :products, through: :product_review_products

  has_many :content_translations, as: :translatable, foreign_key: "content_id", foreign_type: "content_type"

  def sanitized_title
    self.title.gsub(/[\'\"]/, "")
  end

  def self.all_for_website(website)
    r = []
    find_each do |pr|
      r << pr if pr.products.select{|p| p if p.belongs_to_this_brand?(website)}.size > 0
    end
    r
  end

  # Alias for search results link_name
  def link_name
    self.send(link_name_method)
  end

  def link_name_method
    :title
  end

  # Alias for search results content_preview
  def content_preview
    self.send(content_preview_method)
  end

  def content_preview_method
    :body
  end

  # Used for link checking
  def url
    self.external_link
  end

  # For cross-functionality with News
  def post_on
    self.created_at.to_date
  end

end
