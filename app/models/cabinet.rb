class Cabinet < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name
  
  has_many :product_cabinets
  has_many :products, through: :product_cabinets
  validates :name, presence: true, uniqueness: true

  has_attached_file :cab_image, 
    styles: { large: "550x370", 
      medium: "480x360", 
      small: "240x180",
      thumb: "100x100", 
      tiny: "64x64", 
      tiny_square: "64x64#" 
    }
  validates_attachment :cab_image, content_type: { content_type: /\Aimage/i }
    
  after_save :translate

  # Translates this record into other languages. 
  def translate
    if self.products && self.products.first
      ContentTranslation.auto_translate(self, self.products.first.brand)
    end
  end
  handle_asynchronously :translate

end
