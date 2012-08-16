class RsoPanel < ActiveRecord::Base
  belongs_to :brand
  has_many :rso_navigations, order: :position # (if this is a left panel)
  validates :name, presence: true, uniqueness: {scope: :brand_id}
  has_attached_file :rso_panel_image,
    styles: { main: "680x370#", left: "250x370#",
      mobile: "290x480",
      thumb: "100x100", 
      tiny: "64x64", 
      tiny_square: "64x64#" 
    },
    path: ":rails_root/public/system/:attachment/:id/:style/:filename",
    url: "/system/:attachment/:id/:style/:filename"

  attr_accessor :delete_image
  before_save :check_to_delete_image
  
  def check_to_delete_image
    unless self.rso_panel_image_file_name_changed? || self.rso_panel_image_updated_at_changed?
      if self.delete_image
        self.rso_panel_image = nil
      end
    end
  end
  
  def self.slides(panel_type="main")
    where(name: panel_type).where("rso_panel_image_file_name IS NOT NULL AND rso_panel_image_file_name != ''").order("rso_panel_image_updated_at DESC")
  end
  
  # used in slideshow helper
  def string_value
    self.url
  end
  
  def slide
    self.rso_panel_image
  end
  
end
