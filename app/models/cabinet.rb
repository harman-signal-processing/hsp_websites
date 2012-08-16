class Cabinet < ActiveRecord::Base
  has_many :product_cabinets
  has_many :products, through: :product_cabinets
  validates_presence_of :name
  validates_uniqueness_of :name
  has_friendly_id :name, use_slug: true, approximate_ascii: true, max_length: 100
  has_attached_file :cab_image, 
    styles: { large: "550x370", 
      medium: "480x360", 
      small: "240x180",
      thumb: "100x100", 
      tiny: "64x64", 
      tiny_square: "64x64#" 
    },
    path: ":rails_root/public/system/:attachment/:id/:style/:filename",
    url: "/system/:attachment/:id/:style/:filename"

end
