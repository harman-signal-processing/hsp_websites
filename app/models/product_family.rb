class ProductFamily < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates

  belongs_to :brand, touch: true
  has_many :product_family_products, -> { order('product_family_products.position').includes(:product) }, dependent: :destroy
  has_many :products, -> { order("product_family_products.position").includes([:product_status, :product_families]) }, through: :product_family_products
  has_many :locale_product_families
  has_many :market_segment_product_families, dependent: :destroy
  has_many :features, -> { order('position') }, as: :featurable, dependent: :destroy
  has_many :product_family_case_studies, -> { order('position') }, dependent: :destroy
  has_many :content_translations, as: :translatable, foreign_key: "content_id", foreign_type: "content_type"

  has_attached_file :family_photo, { styles: { medium: "300x300>", thumb: "100x100>" }}.merge(S3_STORAGE)
  has_attached_file :family_banner, { styles: { medium: "300x300>", thumb: "100x100>" }}.merge(S3_STORAGE)
  has_attached_file :title_banner, { styles: { medium: "300x300>", thumb: "100x100>" }}.merge(S3_STORAGE)
  has_attached_file :background_image, S3_STORAGE

  validates_attachment :family_photo, content_type: { content_type: /\Aimage/i }
  validates_attachment :family_banner, content_type: { content_type: /\Aimage/i }
  validates_attachment :title_banner, content_type: { content_type: /\Aimage|pdf/i }
  validates_attachment :background_image, content_type: { content_type: /\Aimage/i }

  validates :brand_id, presence: true
  validates :name, presence: true
  validate :parent_not_itself

  acts_as_tree order: :position, scope: :brand_id
  # acts_as_list scope: :brand_id, -> { order('position') }

  scope :options_not_associated_with_this_product, -> (product, website) { 
    product_family_ids_already_associated_with_this_product = ProductFamilyProduct.where("product_id = ?", product.id).map{|pfp| pfp.product_family_id }
    product_families_not_associated_with_this_product = self.nested_options(website)
        .select{|item| product_family_ids_already_associated_with_this_product.exclude?(item.keys[0]) }
        .reject(&:empty?)
        .map{|item| ProductFamily.new(id: item.keys[0], name: item.values[0]) }

    product_families_not_associated_with_this_product
  }

  def slug_candidates
    [
      :name,
      [:brand_name, :name],
      [:brand_name, :name, :id]
    ]
  end

  def brand_name
    self.brand.name
  end

  def should_generate_new_friendly_id?
    true
  end

  # All top-level ProductFamilies--not locale aware
  #  w = a Brand or a Website
  def self.all_parents(w)
    brand_id = (w.is_a?(Brand)) ? w.id : w.brand_id
    where(brand_id: brand_id).where(parent_id: nil).order(:position)
  end

  def self.nested_options(w)
    options = []
    all_parents(w).each do |p|
      options << { p.id => p.name  }
      if p.children.length > 0
        options += p.children_options(1)
      end
      options << {}
    end
    options
  end

  def children_options(indent = 0)
    bump = "&#160;" * indent * 2
    options = []
    children.each do |c|
      options << { c.id => "#{bump}#{c.name}" }
      if c.children.length > 0
        options += c.children_options(indent + 1)
      end
    end
    options
  end

  # Collection of all families with at least one active product
  def self.all_with_current_products(website, locale)
    where(brand_id: website.brand_id).order("position").select do |f|
      f if (f.current_products.size > 0 || f.children_with_current_products(website, locale: locale).size > 0) && f.locales(website).include?(locale.to_s)
    end
  end

  # Collection of all families with at least one current or discontinued product
  # for the given website and locale
  def self.all_with_current_or_discontinued_products(website, locale)
    where(brand_id: website.brand_id).order("position").select do |f|
      f if (f.current_and_discontinued_products.size > 0 || f.current_products_plus_child_products(website).size > 0) && f.locales(website).include?(locale.to_s)
    end
  end

  # Parent categories with at least one active product
  def self.parents_with_current_products(website, locale)
    pf = []
    top_level_for(website).each do |f|
      if f.locales(website).include?(locale.to_s)
        if f.current_products.size > 0
          pf << f
        else
          current_children = 0
          f.children.includes(:products).each do |ch|
            current_children += ch.current_products_plus_child_products(website).size
            last if current_children > 0
          end
          pf << f if current_children > 0
        end
      end
    end
    pf
  end

  def self.top_level_for(brand)
    brand_id = brand.is_a?(Website) ? brand.brand_id : brand.id
    where(brand_id: brand_id, hide_from_navigation: false).where("parent_id IS NULL or parent_id = 0").order('position').includes(:products)
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
    discontinued_products ||= products.includes(:product_status).where(product_status: ProductStatus.discontinued_ids)
  end

  # Collection of all the locales where this ProductFamily should appear.
  # By definition, it should include ALL locales unless there is one or more
  # limitation specified.
  def locales(website)
    if self.parent.present? && self.parent.locale_product_families.size > 0
      parent.locales(website)
    else
      @locales ||= (locale_product_families.size > 0) ? locale_product_families.pluck(:locale) : website.list_of_all_locales
    end
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
    @current_products ||= products.where(product_status: ProductStatus.current_ids)
  end

  # Determine current and discontinued products for the ProductFamily
  def current_and_discontinued_products
    @current_and_discontinued_products ||= current_products + discontinued_products
  end

  # w = a Brand or a Website
  def current_products_plus_child_products(w, opts={})
    cp = self.current_products
    children_with_current_products(w, opts).each do |pf|
      cp += pf.current_products_plus_child_products(w, opts)
    end
    if opts[:nosort]
      cp.uniq
    else
      cp.sort_by(&:name).uniq
    end
  end

  def first_product_with_photo(w)
    if current_products.length > 0
      current_products.each do |product|
        return product if product.primary_photo.present?
      end
    elsif current_products_plus_child_products(w).length > 0
      current_products_plus_child_products(w, nosort: true).each do |product|
        return product if product.primary_photo.present?
      end
    end
    false
  end

  # Alias for search results link_name
  def link_name
    self.send(:link_name_method)
  end

  def link_name_method
    :name
  end

  # Alias for search results content_preview
  def content_preview
    #"#{self.intro} " + self.current_products.collect{|p| p.name}.join(", ")
    self.send(content_preview_method)
  end

  def content_preview_method
    :intro
  end

  # Determine if we should show product comparison boxes for this product family
  def show_comparisons?
    @show_comparisons ||= brand.respond_to?(:show_comparisons) &&
      !!(brand.show_comparisons) &&
      (self.current_products.length > 1 || self.children_with_current_products(brand).length > 0)
  end

  # Load this ProductFamily's children families with at least one active product
  # w = a Brand or a Website
  def children_with_current_products(w, options={})
    default_options = { depth: 1 }
    options = default_options.merge options
    brand_id = (w.is_a?(Brand)) ? w.id : w.brand_id
    ids = []
    children.where(brand_id: brand_id, hide_from_navigation: false).includes(:products).each do |pf|
      if !pf.requires_login? && (pf.current_products.size > 0 || pf.children_with_current_products(w, options).size > 0)
        unless options[:locale].present? && !pf.locales(w).include?(options[:locale].to_s)
          ids << pf.id
          if options[:depth] > 1
            sub_options = options.merge(depth: options[:depth] - 1)
            ids += pf.children_with_current_products(w, sub_options).pluck(:id)
          end
        end
      end
    end
    ProductFamily.where(id: ids.flatten.uniq).order("position")
  end

  def all_children(w)
    brand_id = (w.is_a?(Brand)) ? w.id : w.brand_id
    all = []
    children.where(brand_id: brand_id).each do |ch|
      all << ch
      if ch.children.length > 0
        all += ch.all_children(w)
      end
    end
    all.flatten.uniq
  end

  def children_with_toolkit_products(w)
    brand_id = (w.is_a?(Brand)) ? w.id : w.brand_id
    children.includes(:products).select do |pf|
      pf if (pf.toolkit_products.size > 0 || pf.children_with_toolkit_products(w).size > 0) && pf.brand_id == brand_id
    end
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
    self.parent ? "#{name} (#{parent.name})" : name
  end

  def parent_not_itself
    errors.add(:parent_id, "can't be itself") if !self.new_record? && self.parent_id == self.id
  end

  # Checks if this password requires a username and password:
  def requires_login?
    !!!(self.preview_username.blank? && self.preview_password.blank?)
  end

end

