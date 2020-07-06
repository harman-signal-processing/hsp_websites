class Installation < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates

  has_attached_file :thumbnail, {
    styles: {
      banner: "1500>x400",
      large: "600>x370",
      email: "580",
      medium_square: "480x480#",
      medium: "480x480>",
      small: "240",
      small_square: "250x250#",
      thumb: "100x100>",
      thumb_square: "100x100#",
      tiny: "64x64>",
      tiny_square: "64x64#"
    }, processors: [:thumbnail, :compression]
  }.merge(S3_STORAGE)
  validates_attachment :thumbnail, content_type: { content_type: /\Aimage/i }

  validates :title, presence: true, uniqueness: { scope: :brand_id }
  validates :brand_id, presence: true

  belongs_to :brand

  def slug_candidates
    [
      :sanitized_title,
      [:brand_name, :sanitized_title],
    ]
  end

  def brand_name
    self.brand.name
  end

  def should_generate_new_friendly_id?
    true
  end

  def sanitized_title
    self.title.gsub(/[\'\"]/, "")
  end

  def self.all_for_website(website)
    where(brand_id: website.brand_id).all
  end

  # Alias for search results link_name
  def link_name
    self.title
  end

  # Alias for search results content_preview
  def content_preview
    self.body
  end

end
