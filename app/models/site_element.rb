class SiteElement < ActiveRecord::Base
  belongs_to :brand, touch: true
  has_attached_file :resource, 
    styles: { large: "550x370", 
      medium: "480x360", 
      small: "240x180",
      thumb: "100x100", 
      tiny: "64x64", 
      tiny_square: "64x64#" 
    },
    path: ":rails_root/public/system/:attachment/:id_:timestamp/:basename_:style.:extension",
    url: "/system/:attachment/:id_:timestamp/:basename_:style.:extension"
    
  has_attached_file :executable,
    path: ":rails_root/public/system/:attachment/:id_:timestamp/:basename_:style.:extension",
    url: "/system/:attachment/:id_:timestamp/:basename_:style.:extension"

  validates :brand, :name, presence: true
  has_many :product_site_elements, dependent: :destroy, inverse_of: :site_element
  has_many :products, through: :product_site_elements
  
  def self.resource_types
    defaults = ["Wallpaper"]
    begin
      from_db = select("distinct(resource_type)").order("resource_type").all.collect{|r| r.resource_type}
      (from_db + defaults).uniq.sort{|a,b| a.downcase <=> b.downcase}
    rescue
      defaults
    end
  end
  
  def is_image?
    !!(resource_file_name.to_s.match(/(png|jpg|jpeg|tif|tiff|bmp|gif)$/i))
  end
  
end
