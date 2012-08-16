class ProductFamily < ActiveRecord::Base
  belongs_to :brand, touch: true
  has_many :product_family_products, order: :position, dependent: :destroy
  has_many :products, through: :product_family_products, order: "product_family_products.position"
  has_many :locale_product_families
  has_many :market_segment_product_families, dependent: :destroy
  has_friendly_id :name, use_slug: true, approximate_ascii: true, max_length: 100
  has_attached_file :family_photo, 
    styles: { medium: "300x300>", thumb: "100x100>" },
    path: ":rails_root/public/system/:attachment/:id/:style/:filename",
    url: "/system/:attachment/:id/:style/:filename"

  has_attached_file :family_banner, 
    styles: { medium: "300x300>", thumb: "100x100>" },
    path: ":rails_root/public/system/:attachment/:id/:style/:filename",
    url: "/system/:attachment/:id/:style/:filename"

  has_attached_file :title_banner, 
    styles: { medium: "300x300>", thumb: "100x100>" },
    path: ":rails_root/public/system/product_family/:attachment/:id/:style/:filename",
    url: "/system/product_family/:attachment/:id/:style/:filename"

  has_attached_file :background_image,
    path: ":rails_root/public/system/:attachment/:id/:style/:filename",
    url: "/system/:attachment/:id/:style/:filename"

  validates_presence_of :brand_id, :name
  acts_as_tree order: :position, scope: :brand_id
  # acts_as_list scope: :brand_id, order: :position
  
  define_index do
    indexes :name
    indexes :intro
    indexes :keywords
  end
  
  # All top-level ProductFamilies--not locale aware
  def self.all_parents(website)
    where(brand_id: website.brand_id).where(parent_id: nil).order(:position)
  end
  
  # Collection of all families with at least one active product
  def self.all_with_current_products(website, locale)
    pf = []
    find_all_by_brand_id(website.brand_id, order: :position).each do |f|
      pf << f if f.current_products.size > 0 && f.locales(website).include?(locale.to_s)
    end
    pf
  end

  # Parent categories with at least one active product
  def self.parents_with_current_products(website, locale)
    pf = []
    find(:all,
      conditions: ["brand_id = ? AND (parent_id IS NULL or parent_id = 0)", website.brand_id],
      order: :position).each do |f|
        if f.current_products.size > 0
          pf << f if f.locales(website).include?(locale.to_s)
        else
          current_children = 0
          f.children.each do |ch|
            current_children += ch.current_products.size
          end
          if current_children > 0
            pf << f if f.locales(website).include?(locale.to_s)
          end
	      end
    end
    pf
  end
  
  # Parent categories for super nav (originally designed for Lexicon site)
  def self.parents_for_supernav(website, locale)
    pf = []
    where(brand_id: website.brand_id).where("parent_id IS NULL or parent_id = 0").order(:position).each do |f|
      pf << f if !(f.hide_from_homepage) && f.locales(website).include?(locale.to_s)
    end
    pf
  end

  # Collection of all the locales where this ProductFamily should appear.
  # By definition, it should include ALL locales unless there is one or more
  # limitation specified.
  def locales(website)
    limit = self.locale_product_families.all
    (limit.size > 0) ? limit.collect{|lpf| lpf.locale} : website.list_of_all_locales
  end
  
  # Sibling categories with at least one active product
  def siblings_with_current_products
    s = []
    siblings.each do |sibling|
      s << sibling if sibling.current_products.size > 0
    end
    s
  end
  
  # Determine only 'current' products for the ProductFamily
  def current_products
    cp = []
    self.products.each do |p|
      cp << p if p.product_status.is_current?
    end
    cp
  end
  
  # Alias for search results link_name
  def link_name
    self.name
  end
  
  # Alias for search results content_preview
  def content_preview
    "#{self.intro} " + self.current_products.collect{|p| p.name}.join(", ")
  end
  
  # Load this ProductFamily's children families with at least one active product
  def children_with_current_products(website)
    children.select{|pf| pf if pf.current_products.size > 0 && pf.brand_id == website.brand_id}
  end

  # Does this product family have a custom background image or color?
  def has_custom_background?
    !self.background_image_file_name.blank? || !self.background_color.blank?
  end
  
  # Format a CSS background setting value based on this product family's custom settings
  def custom_background
    css = ""
    css += "background-color: #{self.background_color};" unless self.background_color.blank?
    if self.background_image_file_name.blank?
      css += "background-image: none; "
    else
      css += "background-image: url('#{self.background_image.url("original", false)}'); "
      css += "background-position: center top; "
      css += "background-repeat: repeat-y; "
    end
    css
  end
  
end
