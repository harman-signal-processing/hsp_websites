class Badge < ApplicationRecord
  has_many :product_badges, dependent: :destroy
  has_many :products, through: :product_badges

  has_attached_file :image, {
    styles: {
      large: "128x128#",
      medium: "64x64#",
      small: "32x32#"
    },
    convert_options: {
      large: "-gravity center -extent 128x128",
      medium: "-gravity center -extent 64x64",
      small: "-gravity center -extent 32x32"
    }
  }.merge(S3_STORAGE)

  validates_attachment :image, content_type: { content_type: /\Aimage/i }
  validates :name, presence: true, uniqueness: true
end
