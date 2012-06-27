class Software < ActiveRecord::Base
  has_many :product_softwares, :dependent => :destroy
  has_many :products, :through => :product_softwares
  has_many :software_attachments
  has_many :software_training_classes, :dependent => :destroy
  has_many :training_classes, :through => :software_training_classes
  has_many :software_training_modules, :dependent => :destroy, :order => :position
  has_many :training_modules, :through => :software_training_modules
  has_friendly_id :name, :use_slug => true, :approximate_ascii => true, :max_length => 100
  validates_presence_of :name, :brand_id
  has_attached_file :ware,
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"

  after_initialize :set_default_counter
  belongs_to :brand, touch: true
  
  define_index do
    indexes :name
    indexes :version
    indexes :platform
    indexes :description
  end
  
  def set_default_counter
    self.download_count ||= 0
  end
    
  def increment_count
    set_default_counter
    self.download_count += 1
    self.save
  end
  
  def formatted_name
    f = self.name
    f += " v #{self.version}" unless self.version.blank?
    f += " (#{self.platform})" unless self.platform.blank?
    f
  end

  # Alias for search results link_name
  def link_name
    self.formatted_name
  end
  
  # Alias for search results content_preview
  def content_preview
    self.description
  end

end
