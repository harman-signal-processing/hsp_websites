class NewsImage < ApplicationRecord

  has_attached_file :image, {
    styles: {
      banner: ["1500>x400", :webp],
      large: ["600>x370", :webp],
      email: "580",
      medium: "350x350>",
      small: "240",
      small_square: "250x250#",
      thumb: "100x100>",
      thumb_square: "100x100#",
      tiny: "64x64>",
      tiny_square: "64x64#"
    },
    processors: [:thumbnail, :compression],
  }
  validates_attachment :image, content_type: { content_type: /\Aimage/i }

  belongs_to :news, touch: true
end
