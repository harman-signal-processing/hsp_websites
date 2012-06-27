class Promotion < ActiveRecord::Base
  validates_presence_of :name, :brand_id
  validates_uniqueness_of :name
  has_many :product_promotions
  has_many :products, :through => :product_promotions
  belongs_to :brand
  has_friendly_id :sanitized_name, :use_slug => true, :approximate_ascii => true, :max_length => 100
  has_attached_file :promo_form,
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"

  has_attached_file :tile, 
    :styles => { :large => "550x370", 
      :medium => "480x360", 
      :small => "240x180",
      :thumb => "100x100", 
      :tiny => "64x64", 
      :tiny_square => "64x64#" 
    },
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
    
  def sanitized_name
    self.name.gsub(/[\'\"]/, "")
  end
  
  def self.current(website)
    where(:brand_id => website.brand_id).where(["show_start_on <= ? AND show_end_on >= ?", Date.today, Date.today])
  end
  
  def self.all_for_website(website)
    current(website).order("end_on ASC")
  end
    
  # !blank? doesn't work because tiny MCE supplies a blank line even
  # if we don't want it...
  def has_description?
    self.description.size > 28
  end
end
