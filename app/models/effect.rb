class Effect < ApplicationRecord
  extend FriendlyId
  friendly_id :name

  has_many :product_effects
  has_many :products, through: :product_effects
  belongs_to :effect_type, optional: true
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_attached_file :effect_image,
    styles: { large: "550x370",
      medium: "480x360",
      small: "240x180",
      thumb: "100x100",
      tiny: "64x64",
      tiny_square: "64x64#"
    }
  validates_attachment :effect_image, content_type: { content_type: /\Aimage/i }

end
