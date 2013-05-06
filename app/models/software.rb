class Software < ActiveRecord::Base
  attr_accessor :replaces_id
  has_many :product_softwares, dependent: :destroy, order: "product_position"
  has_many :products, through: :product_softwares
  has_many :software_attachments
  has_many :software_training_classes, dependent: :destroy
  has_many :training_classes, through: :software_training_classes
  has_many :software_training_modules, dependent: :destroy, order: :position
  has_many :training_modules, through: :software_training_modules
  has_many :software_operating_systems, dependent: :destroy
  has_many :operating_systems, through: :software_operating_systems
  has_friendly_id :formatted_name, use_slug: true, approximate_ascii: true, max_length: 100
  validates_presence_of :name, :brand_id
  has_attached_file :ware,
    path: ":rails_root/public/system/:attachment/:id/:style/:filename",
    url: "/system/:attachment/:id/:style/:filename"

  after_initialize :set_default_counter, :determine_platform
  after_save :replace_old_version
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

  def previous_versions
    self.class.where(current_version_id: self.id).order("created_at DESC")
  end

  def replaced_by
    if self.current_version_id.present? && self.current_version_id != self.id 
      self.class.find(self.current_version_id)
    end
  end

  def replace_old_version
    if self.replaces_id && self.replaces_id.to_i > 0
      self.class.where(current_version_id: self.replaces_id).update_all(current_version_id: self.id, active: false)
      self.class.where(id: self.replaces_id).update_all(current_version_id: self.id, active: false)
      ProductSoftware.where(software_id: self.replaces_id).each do |ps|
        ProductSoftware.where(software_id: self.id, product_id: ps.product_id).first_or_create
      end
    end
  end
  
  def formatted_name
    f = self.name
    f += " v#{self.version}" unless self.version.blank?
    f += " (#{self.platform})" unless self.platform.blank?
    f
  end

  # If the platform field is blank
  def determine_platform
    if platform.blank?
      (self.operating_systems.pluck(:name) + self.operating_systems.pluck(:arch)).join(" ")
    end
  end

  # Alias for search results link_name
  def link_name
    self.formatted_name
  end
  
  # Alias for search results content_preview
  def content_preview
    self.description
  end

  def has_additional_info?
    !!(self.description.present? || self.training_modules.count > 0 || self.software_attachments.count > 0 || self.training_classes.count > 0 || self.previous_versions.count > 0)
  end

  def current_products
    @current_products ||= self.products & brand.current_products
  end

end
