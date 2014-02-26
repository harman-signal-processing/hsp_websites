class Cabinet < ActiveRecord::Base
  has_many :product_cabinets
  has_many :products, through: :product_cabinets
  validates :name, presence: true, uniqueness: true
  has_friendly_id :name, use_slug: true, approximate_ascii: true, max_length: 100
  has_attached_file :cab_image, 
    styles: { large: "550x370", 
      medium: "480x360", 
      small: "240x180",
      thumb: "100x100", 
      tiny: "64x64", 
      tiny_square: "64x64#" 
    }
    
  after_save :translate

  # Translates this record into other languages. 
  def translate
    if self.products && self.products.first
      ContentTranslation.auto_translate(self, self.products.first.brand)
    end
  end
  handle_asynchronously :translate

end
