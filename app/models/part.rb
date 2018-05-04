class Part < ApplicationRecord
  has_many :product_parts, dependent: :destroy
  has_many :products, through: :product_parts

  has_attached_file :photo, {
    styles: {
      large: "640x480",
      medium: "480x360",
      horiz_medium: "670x275",
      vert_medium: "375x400",
      medium_small: "150x225",
      small: "240x180",
      horiz_thumb: "170x80",
      thumb: "100x100",
      tiny: "64x64",
      tiny_square: "64x64#"
    }}.merge(S3_STORAGE)
  validates_attachment :photo, content_type: { content_type: /\Aimage/i }

  validates :part_number, presence: true

  acts_as_tree

end
