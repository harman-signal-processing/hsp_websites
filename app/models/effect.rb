class Effect < ActiveRecord::Base
  has_many :product_effects
  has_many :products, through: :product_effects
  belongs_to :effect_type
  validates_presence_of :name
  validates_uniqueness_of :name
  has_friendly_id :name, use_slug: true, approximate_ascii: true, max_length: 100
  has_attached_file :effect_image, 
    styles: { large: "550x370", 
      medium: "480x360", 
      small: "240x180",
      thumb: "100x100", 
      tiny: "64x64", 
      tiny_square: "64x64#" 
    },
    path: ":rails_root/public/system/:attachment/:id_:timestamp/:basename_:style.:extension",
    url: "/system/:attachment/:id_:timestamp/:basename_:style.:extension"

  after_save :translate

  # Translates this record into other languages. 
  def translate
    if self.products && self.products.first
      ContentTranslation.auto_translate(self, self.products.first.brand)
    end
  end
  handle_asynchronously :translate

end
