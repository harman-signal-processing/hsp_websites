class ProductFamily < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name
  
  belongs_to :brand, touch: true
  has_many :product_family_products, -> { order('position').includes(:product) }, dependent: :destroy
  has_many :products, -> { order("product_family_products.position").includes([:product_status, :product_families]) }, through: :product_family_products
  has_many :locale_product_families
  has_many :market_segment_product_families, dependent: :destroy
  
  has_attached_file :family_photo, { styles: { medium: "300x300>", thumb: "100x100>" }}.merge(S3_STORAGE)
  has_attached_file :family_banner, { styles: { medium: "300x300>", thumb: "100x100>" }}.merge(S3_STORAGE)
  has_attached_file :title_banner, { styles: { medium: "300x300>", thumb: "100x100>" }}.merge(S3_STORAGE)
  has_attached_file :background_image, S3_STORAGE

  validates_attachment :family_photo, content_type: { content_type: /\Aimage/i }
  validates_attachment :family_banner, content_type: { content_type: /\Aimage/i }
  validates_attachment :title_banner, content_type: { content_type: /\Aimage/i }
  validates_attachment :background_image, content_type: { content_type: /\Aimage/i }

  validates :brand_id, presence: true
  validates :name, presence: true
  validate :parent_not_itself

  acts_as_tree order: :position, scope: :brand_id
  # acts_as_list scope: :brand_id, -> { order('position') }
  after_save :translate
  
  # All top-level ProductFamilies--not locale aware
  #  w = a Brand or a Website
  def self.all_parents(w)
    brand_id = (w.is_a?(Brand)) ? w.id : w.brand_id
    where(brand_id: brand_id).where(parent_id: nil).order(:position)
  end
  
  # Collection of all families with at least one active product
  def self.all_with_current_products(website, locale)
    pf = []
    where(brand_id: website.brand_id).order("position").all.each do |f|
      pf << f if f.current_products.size > 0 && f.locales(website).include?(locale.to_s)
    end
    pf
  end

  # Collection of all families with at least one current or discontinued product
  # for the given website and locale
  def self.all_with_current_or_discontinued_products(website, locale)
    pf = []
    where(brand_id: website.brand_id).order("position").all.each do |f|
      pf << f if (f.current_products_plus_child_products(website).length > 0 || f.current_and_discontinued_products.length > 0) && f.locales(website).include?(locale.to_s)
    end
    pf
  end 

  # Parent categories with at least one active product
  def self.parents_with_current_products(website, locale)
    pf = []
    top_level_for(website).each do |f|
        if f.current_products.size > 0
          pf << f if f.locales(website).include?(locale.to_s)
        else
          current_children = 0
          f.children.includes(:products).each do |ch|
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
    top_level_for(website).each do |f|
      pf << f if !(f.hide_from_homepage) && f.locales(website).include?(locale.to_s) && (f.current_products.size > 0 || f.children_with_current_products(website).size > 0)
    end
    pf
  end

  def self.top_level_for(brand)
    brand_id = brand.is_a?(Website) ? brand.brand_id : brand.id
    where(brand_id: brand_id).where("parent_id IS NULL or parent_id = 0").order('position').includes(:products)
  end

  # We flatten the families for the employee store. 
  def employee_store_products
    products = []
    products += current_products_with_employee_pricing
    children.each do |child|
      products += child.employee_store_products
    end
    products.flatten.uniq
  end

  # One level of current products for the store
  def current_products_with_employee_pricing
    if Rails.env.production?
      self.current_products.select{|p| p if p.harman_employee_price.present? && p.can_be_registered?}
    else
      self.current_products_for_toolkit
    end
  end

  # Recurses down the product family trees to collect all products for the toolkit
  def toolkit_products
    products = []
    products += current_products_for_toolkit
    children.each do |child|
      products += child.toolkit_products
    end
    products.flatten.uniq
  end

  # One level of products for the toolkit--just this family
  def current_products_for_toolkit
    self.products.includes(:product_status).select{|p| p if p.show_on_toolkit? && !p.discontinued? }
  end

  # Recurses down the product family trees to collect all the disontinued products (for the toolkit)
  def all_discontinued_products
    products = []
    products += discontinued_products
    children.each do |child|
      products += child.all_discontinued_products
    end
    products.flatten.uniq
  end

  def discontinued_products
    products.includes(:product_status).select{|p| p if p.discontinued?}
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
    # siblings.each do |sibling|
    self.class.where(parent_id: self.parent_id).where("id != ?", self.id).includes(:products).each do |sibling|
      s << sibling if sibling.current_products.size > 0
    end
    s
  end
  
  # Determine only 'current' products for the ProductFamily
  def current_products
    cp = []
    self.products.includes(:product_status).each do |p|
      cp << p if p.product_status.is_current?
    end
    cp
  end

  # Determine current and discontinued products for the ProductFamily
  def current_and_discontinued_products
    current_products + discontinued_products
  end

  # w = a Brand or a Website
  def current_products_plus_child_products(w)
    cp = self.current_products 
    children_with_current_products(w).each do |pf|
      cp += pf.current_products_plus_child_products(w)
    end
    cp.uniq.sort_by(&:name)
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
  # w = a Brand or a Website
  def children_with_current_products(w)
    brand_id = (w.is_a?(Brand)) ? w.id : w.brand_id
    children.includes(:products).select{|pf| pf if pf.current_products.size > 0 && pf.brand_id == brand_id}
  end

  def children_with_toolkit_products(w)
    brand_id = (w.is_a?(Brand)) ? w.id : w.brand_id
    children.includes(:products).select{|pf| pf if pf.toolkit_products.size > 0 && pf.brand_id == brand_id}
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

  # Used to collect parent name for this family (if any)
  def tree_names
    self.parent ? "#{name} #{parent.name}" : name
  end

  # Translates this record into other languages. 
  def translate
    ContentTranslation.auto_translate(self, self.brand)
  end
  handle_asynchronously :translate

  def parent_not_itself
    errors.add(:parent_id, "can't be itself") if !self.new_record? && self.parent_id == self.id    
  end
  
end
