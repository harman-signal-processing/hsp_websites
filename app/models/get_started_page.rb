class GetStartedPage < ApplicationRecord
  extend FriendlyId
  friendly_id :name

  belongs_to :brand
  has_many :get_started_page_products, dependent: :destroy
  has_many :products, through: :get_started_page_products
  has_many :get_started_panels, -> { order "position" }

  has_attached_file :header_image, {
    styles: { large: "1000x533",
      medium: "500x265",
      small: "250x132",
      thumb: "100x100",
      title: "86x86",
      tiny: "64x64",
      tiny_square: "64x64#"
    }, processors: [:thumbnail, :compression] }
  validates_attachment :header_image, content_type: { content_type: /\Aimage/i }

  def cookie_name
    "registered_for_#{ self.friendly_id }".to_sym
  end

  def has_user_guides?
    ProductDocument.where(product_id: self.products.pluck(:id)).size > 0
  end

  def has_software?
    ProductSoftware.joins(:software).where(product_id: self.products.pluck(:id), softwares: {active: true}).size > 0
  end
end

