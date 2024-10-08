class Badge < ApplicationRecord
  has_many :product_badges, dependent: :destroy
  has_many :products, through: :product_badges

  scope :not_associated_with_this_product, -> (product) {
    unscoped.where.not(id: product.badges.select(:id))
  }

  has_attached_file :image,
    styles: {
      large: "128x128",
      medium: "64x64",
      small: "32x32"
    }

  validates_attachment :image, content_type: { content_type: /\Aimage/i }
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
