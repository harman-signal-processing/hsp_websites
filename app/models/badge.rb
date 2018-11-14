class Badge < ApplicationRecord
  has_many :product_badges, dependent: :destroy
  has_many :products, through: :product_badges

  scope :not_associated_with_this_product, -> (product, website) { 
    badge_ids_already_associated_with_this_product = ProductBadge.where("product_id = ?", product.id).map{|ps| ps.badge_id }
    badges_not_associated_with_this_product = Badge.where.not(id: badge_ids_already_associated_with_this_product)    
    badges_not_associated_with_this_product
  }

  has_attached_file :image, {
    styles: {
      large: "128x128",
      medium: "64x64",
      small: "32x32"
    }
  }.merge(S3_STORAGE)

  validates_attachment :image, content_type: { content_type: /\Aimage/i }
  validates :name, presence: true, uniqueness: true
end
