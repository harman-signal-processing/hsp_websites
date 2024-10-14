class BannerLocale < ApplicationRecord
  belongs_to :banner, touch: true
  validates :locale, presence: true, uniqueness: { scope: :banner_id }

  acts_as_list scope: [:banner_id, :locale]

  has_attached_file :slide, {
    styles: {
      large: ["1920>x692", :webp],
      large_2x: ["3840>x1384", :webp],
      medium: "350x350>",
      thumb: "100x100>",
      tiny: "64x64>",
      tiny_square: "64x64#"
    },
    processors: [:thumbnail, :compression],
  }.merge(SETTINGS_STORAGE)

  validates_attachment :slide,
    content_type: { content_type: /\A(image|video)/i },
    size: { in: 0..300.kilobytes }

  before_slide_post_process :skip_for_video, :skip_for_gifs

  process_in_background :slide

  def skip_for_video
    ! slide_content_type.match?(/video/)
  end

  def skip_for_gifs
    ! slide_content_type.match?(/gif/)
  end

  def has_content?
    title.present? || content.present? || slide.present?
  end
end
