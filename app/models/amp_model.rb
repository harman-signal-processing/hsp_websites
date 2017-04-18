class AmpModel < ApplicationRecord
  extend FriendlyId
  friendly_id :name

  has_many :product_amp_models
  has_many :products, through: :product_amp_models
  validates :name, presence: true, uniqueness: true

  has_attached_file :amp_image,
    styles: { large: "550x370",
      medium: "480x360",
      small: "240x180",
      thumb: "100x100",
      tiny: "64x64",
      tiny_square: "64x64#"
    }

  validates_attachment :amp_image, content_type: { content_type: /\Aimage/i }
  after_save :translate

  # Translates this record into other languages.
  def translate
    if self.products && self.products.first
      ContentTranslation.auto_translate(self, self.products.first.brand)
    end
  end
  handle_asynchronously :translate

end
