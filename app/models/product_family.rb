class ProductFamily < ApplicationRecord
  include WaveReport
  include GeoAlternative
  extend FriendlyId
  friendly_id :slug_candidates

  belongs_to :brand, touch: true
  has_many :product_family_products, -> { order('product_family_products.position').includes(:product) }, dependent: :destroy
  has_many :products, -> { order("product_family_products.position").includes([:product_status, :product_families]) }, through: :product_family_products
  has_many :locale_product_families
  has_many :market_segment_product_families, dependent: :destroy
  has_many :features, -> { order('position') }, as: :featurable, dependent: :destroy
  has_many :product_family_product_filters, -> { order('position') }
  has_many :product_filters, through: :product_family_product_filters
  has_many :product_family_case_studies, -> { order('position') }, dependent: :destroy
  has_many :content_translations, as: :translatable, foreign_key: "content_id", foreign_type: "content_type"
  has_many :media_translations, as: :translatable, foreign_key: "media_id", foreign_type: "media_type"
  has_many :product_family_testimonials, -> { order('position') }, dependent: :destroy
  has_many :testimonials, through: :product_family_testimonials
  has_many :product_family_customizable_attributes, dependent: :destroy
  has_many :customizable_attributes, through: :product_family_customizable_attributes
  has_many :product_family_videos, -> { order('position') }, dependent: :destroy
  has_many :current_product_counts
  has_many :banners, as: :bannerable, dependent: :destroy
  belongs_to :featured_product, class_name: "Product", optional: true

  after_touch :update_current_product_counts

  has_attached_file :family_photo, { styles: { medium: "300x300>", thumb: "100x100>" }, processors: [:thumbnail, :compression] }
  has_attached_file :family_banner, { styles: { medium: "300x300>", thumb: "100x100>" }, processors: [:thumbnail, :compression] }
  has_attached_file :title_banner, { styles: { medium: "300x300>", thumb: "100x100>" }, processors: [:thumbnail, :compression] }
  has_attached_file :background_image

  validates_attachment :family_photo, content_type: { content_type: /\Aimage/i }
  validates_attachment :family_banner, content_type: { content_type: /\Aimage/i }
  validates_attachment :title_banner, content_type: { content_type: /\Aimage|pdf/i }
  validates_attachment :background_image, content_type: { content_type: /\Aimage/i }

  validates :name, presence: true
  validate :parent_not_itself

  accepts_nested_attributes_for :product_family_videos, reject_if: proc { |pv| pv['youtube_id'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :product_family_products, reject_if: proc { |pfp| pfp['product_id'].blank? }, allow_destroy: true

  acts_as_tree order: :position, scope: :brand_id, touch: true
  # acts_as_list scope: :brand_id, -> { order('position') }

  scope :options_not_associated_with_this_product, -> (product, website) {
    product_family_ids_already_associated_with_this_product = ProductFamilyProduct.where("product_id = ?", product.id).map{|pfp| pfp.product_family_id }
    product_families_not_associated_with_this_product = self.nested_options(website)
        .select{|item| product_family_ids_already_associated_with_this_product.exclude?(item.keys[0]) }
        .reject(&:empty?)
        .map{|item| self.new(id: item.keys[0], name: item.values[0]) }

    product_families_not_associated_with_this_product
  }

  scope :options_not_associated_with_this_testimonial, -> (testimonial, website) {
    product_family_ids_already_associated_with_this_testimonial = ProductFamilyTestimonial.where(testimonial: testimonial).pluck(:product_family_id)
    self.nested_options(website)
      .select{|item| product_family_ids_already_associated_with_this_testimonial.exclude?(item.keys[0]) }
      .reject(&:empty?)
      .map{|item| self.new(id: item.keys[0], name: item.values[0]) }
  }

  scope :options_not_associated_with_this_customizable_attribute, -> (customizable_attribute, website) {
    product_family_ids_already_associated_with_this_customizable_attribute = ProductFamilyCustomizableAttribute.where(customizable_attribute: customizable_attribute).pluck(:product_family_id)
    self.nested_options(website)
      .select{|item| product_family_ids_already_associated_with_this_customizable_attribute.exclude?(item.keys[0]) }
      .reject(&:empty?)
      .map{|item| self.new(id: item.keys[0], name: item.values[0]) }
  }

  def family_locales
    self.locale_product_families.pluck(:locale)
  end

  def has_parent?
    parent.present?
  end

  def find_ultimate_parent
    self.root
  end

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

  def selector_behavior_options
    opts = [["Default", ""]]
    if self.root?
      opts << ["Root with sub-groups", "root_with_subgroups"]
    elsif self.root == self.parent && self.root.product_selector_behavior == "root_with_subgroups"
      opts << ["Sub-group under #{self.root.name}", "subgroup"]
    end
    opts << ["Exclude", "exclude"]
  end

  def can_have_filters?
    can_have_root_filters? || can_have_subgroup_filters?
  end

  def can_have_root_filters?
    !!(self.root? && self.product_selector_behavior.blank?)
  end

  def can_have_subgroup_filters?
    !!(self.product_selector_behavior == "subgroup")
  end

  def sub_groups
    children.where(product_selector_behavior: "subgroup")
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
      if p.children.size > 0
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
      if c.children.size > 0
        options += c.children_options(indent + 1)
      end
    end
    options
  end

  # Collection of all families with at least one active product
  def self.all_with_current_products(website, locale)
    Rails.cache.fetch("#{website.cache_key_with_version}/#{locale}/product_families/all_with_current_products", expires_in: 2.hours) do
      where(brand_id: website.brand_id).order("position").select do |f|
        f if f.current_products_plus_child_products_count(website) > 0 && f.locales(website).include?(locale.to_s)
      end
    end
  end

  # Collection of all families with at least one current or discontinued product
  # for the given website and locale
  def self.all_with_current_or_discontinued_products(website, locale)
    Rails.cache.fetch("#{website.cache_key_with_version}/#{locale}/product_families/all_with_current_or_discontinued_products", expires_in: 2.hours) do
      where(brand_id: website.brand_id).order("position").select do |f|
        f if ( f.current_products_plus_child_products_count(website) > 0 || f.current_and_discontinued_products.size > 0 ) && f.locales(website).include?(locale.to_s)
      end
    end
  end

  # Parent categories with at least one active product
  def self.parents_with_current_products(website, locale)
    Rails.cache.fetch("#{website.cache_key_with_version}/#{locale}/product_families/parents_with_current_products", expires_in: 2.hours) do
      pf = []
      top_level_for(website).each do |f|
        if f.locales(website).include?(locale.to_s)
          pf << f if f.has_current_products?(website)
        end
      end
      pf
    end
  end

  def self.top_level_for(brand)
    brand_id = brand.is_a?(Website) ? brand.brand_id : brand.id
    where(brand_id: brand_id, hide_from_navigation: false).where("parent_id IS NULL or parent_id = 0").order('position').includes(:products)
  end

  def self.customizable(website, locale)
    Rails.cache.fetch("#{website.cache_key_with_version}/#{locale}/product_families/customizable", expires_in: 2.hours) do
      all_with_current_products(website, locale).select{|pf| pf if pf.product_family_customizable_attributes.size > 0}
    end
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
    self.current_products.select{|p| p if p.harman_employee_price.present? && p.can_be_registered?}
  end

  # Recurses down the product family trees to collect all the disontinued products (for the toolkit)
  def all_discontinued_products
    Rails.cache.fetch("#{cache_key_with_version}/all_discontinued_products", expires_in: 12.hours) do
      products = []
      products += discontinued_products
      children.each do |child|
        products += child.all_discontinued_products
      end
      products.flatten.uniq
    end
  end

  def discontinued_products
    Product.where(id: product_ids_for_current_locale, product_status: ProductStatus.discontinued_ids)
  end

  # Collection of all the locales where this ProductFamily should appear.
  # By definition, it should include ALL locales unless there is one or more
  # limitation specified.
  def locales(website)
    if locale_product_families.size > 0
      locale_product_families.pluck(:locale) - geo_alternative_locales(website)
    elsif self.parent.present? && self.parent.locale_product_families.size > 0
      parent.locales(website) - geo_alternative_locales(website)
    elsif self.find_ultimate_parent.locale_product_families.size > 0
      self.find_ultimate_parent.locales(website) - geo_alternative_locales(website)
    else
      website.list_of_all_locales - geo_alternative_locales(website)
    end
  end

  # Sibling categories with at least one active product
  def siblings_with_current_products
    s = []
    # siblings.each do |sibling|
    self.class.where(parent_id: self.parent_id).where("id != ?", self.id).includes(:products).find_each do |sibling|
      s << sibling if sibling.current_products.size > 0
    end
    s
  end

  # Determine only 'current' products for the ProductFamily
  def current_products
    @current_product ||= products.distinct.where(id: product_ids_for_current_locale, product_status: ProductStatus.current_ids)
  end

  def product_ids_for_current_locale
    Rails.cache.fetch("#{cache_key_with_version}/product_ids_for_current_locale/#{I18n.locale.to_s}/8", expires_in: 12.hours) do
      # match any excluded locales right in the query instead of after
      products.where("products.hidden_locales IS NULL OR (',' + products.hidden_locales + ',') NOT LIKE '%,#{I18n.locale.to_s},%'").pluck(:id)
      #products.select{|p| p unless p.locales_where_hidden.include?(I18n.locale.to_s)}.pluck(:id).uniq
    end
  end

  # Determine current and discontinued products for the ProductFamily
  def current_and_discontinued_products
    @current_and_discontinued_products ||= current_products + discontinued_products
  end

  # w = a Brand or a Website
  def current_products_plus_child_products(w, opts={})
    Rails.cache.fetch("#{cache_key_with_version}/#{w.cache_key_with_version}/#{opts.values.join}/current_products_plus_child_products/#{I18n.locale.to_s}", expires_in: 2.hours) do
      cp = []
      self.current_products.each do |prod|
        if prod.locales(w).include?(I18n.locale.to_s)
          if opts[:check_for_product_selector_exclusions]
            cp << prod unless prod.is_accessory? || prod.brand_id != self.brand_id
          else
            cp << prod
          end
        end
      end
      children_with_current_products(w, opts).each do |pf|
        cp += pf.current_products_plus_child_products(w, opts)
      end
      if opts[:nosort]
        cp.uniq
      else
        cp.sort_by(&:name).uniq
      end
    end
  end

  def has_current_products?(w)
    current_products_plus_child_products_count(w) > 0
  end

  def current_products_plus_child_products_count(w)
    cpc = current_product_counts.where(locale: I18n.locale.to_s).first_or_create
    cpc.current_products_plus_child_products_count.to_i
  end

  def update_current_product_counts
    current_product_counts.each{|cpc| cpc.save}
  end
  handle_asynchronously :update_current_product_counts

  def update_current_product_counts_for_locale(this_locale)
    current_product_counts.where(locale: this_locale).first_or_initialize.save
  end

  # w = a Brand or a Website
  def discontinued_products_plus_child_products(w, opts={})
    Rails.cache.fetch("#{cache_key_with_version}/#{w.cache_key_with_version}/#{opts.values.join}/discontinued_products_plus_child_products/#{I18n.locale.to_s}", expires_in: 2.hours) do
      cp = []
      self.discontinued_products.each do |prod|
        if prod.locales(w).include?(I18n.locale.to_s)
          if opts[:check_for_product_selector_exclusions]
            cp << prod unless prod.is_accessory? || prod.brand_id != self.brand_id
          else
            cp << prod
          end
        end
      end
      children_with_discontinued_products(w, opts).each do |pf|
        cp += pf.discontinued_products_plus_child_products(w, opts)
      end
      if opts[:nosort]
        cp.uniq
      else
        cp.sort_by(&:name).uniq
      end
    end
  end

  # w = Brand or Website
  def current_and_discontinued_products_plus_child_products(w, opts={})
    current_products_plus_child_products(w, opts) + discontinued_products_plus_child_products(w, opts)
  end

  def first_product_with_photo(w)
    if featured_product_id.present? &&
        Product.exists?(featured_product_id) &&
        featured_product.in_production?
      return featured_product if featured_product.primary_photo.present?
    end
    current_products.each do |product|
      return product if product.primary_photo.present?
    end
    current_products_plus_child_products(w, nosort: true).each do |product|
      return product if product.primary_photo.present?
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
    @show_comparisons ||= brand.show_comparisons.present? &&
      !!(brand.show_comparisons) &&
      current_products_plus_child_products_count(brand) > 0
  end

  # Load this ProductFamily's children families with at least one active product
  # w = a Brand or a Website
  def children_with_current_products(w, options={})
    default_options = { depth: 1 }
    options = default_options.merge options
    brand_id = (w.is_a?(Brand)) ? w.id : w.brand_id
    ids = []
    these_children = children.where(brand_id: brand_id, hide_from_navigation: false)
    if !!options[:check_for_product_selector_exclusions]
      these_children = these_children.where.not(product_selector_behavior: "exclude").or(these_children.where(product_selector_behavior: nil))
    end
    these_children.includes(:products).each do |pf|
      if !pf.requires_login? && pf.current_products_plus_child_products_count(w) > 0
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

  # Load this ProductFamily's children families with at least one discontinued product
  # w = a Brand or a Website
  def children_with_discontinued_products(w, options={})
    default_options = { depth: 1 }
    options = default_options.merge options
    brand_id = (w.is_a?(Brand)) ? w.id : w.brand_id
    ids = []
    these_children = children.where(brand_id: brand_id, hide_from_navigation: false)
    if !!options[:check_for_product_selector_exclusions]
      these_children = these_children.where.not(product_selector_behavior: "exclude").or(these_children.where(product_selector_behavior: nil))
    end
    these_children.includes(:products).each do |pf|
      if !pf.requires_login? && (pf.discontinued_products.size > 0 || pf.children_with_discontinued_products(w, options).size > 0)
        unless options[:locale].present? && !pf.locales(w).include?(options[:locale].to_s)
          ids << pf.id
          if options[:depth] > 1
            sub_options = options.merge(depth: options[:depth] - 1)
            ids += pf.children_with_discontinued_products(w, sub_options).pluck(:id)
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
      if ch.children.size > 0
        all += ch.all_children(w)
      end
    end
    all.flatten.uniq
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

  def family_tree
    @family_tree ||= ancestors
  end

  def subgroups_for_product_selector
    @subgroups_for_product_selector ||= children.where(product_selector_behavior: "subgroup")
  end

  def self_and_parents_with_filters
    @self_and_parents_with_filters ||= (product_filters.size > 0) ? [self] + parents_with_filters : parents_with_filters
  end

  def parents_with_filters
    @parents_with_filters ||= family_tree.select{|pf| pf if pf.is_a?(ProductFamily) && pf.product_filters.size > 0}
  end

  def self_and_parents_with_customizable_attributes
    @self_and_parents_customizable_attributes ||= (customizable_attributes.size > 0) ? [self] + parents_with_customizable_attributes : parents_with_customizable_attributes
  end

  def parents_with_customizable_attributes
    @parents_with_customizable_attributes ||= family_tree.select{|pf| pf if pf.is_a?(ProductFamily) && pf.customizable_attributes.size > 0}
  end

  def review_quotes(w)
    current_products_plus_child_products(w, nosort: true).map do |product|
      product.product_reviews
    end.flatten.uniq
  end

  def videos_content_present?
    product_family_videos.select(:id).size > 0
  end

  # Merge the list of locales where this Family should appear with
  # available translations plus our usual English locales
  # Then remove the current locale
  def other_locales_with_translations(website)
    all_locales_with_translations(website) - [I18n.locale.to_s]
  end

  def all_locales_with_translations(website)
    direct_content_translations = content_translations.pluck(:locale).uniq
    fancy_features_translations = features.map{|f| f.content_translations.pluck(:locale).uniq}.flatten
    (locales(website) & (direct_content_translations + fancy_features_translations + ["en", "en-US"]).uniq)
  end

  def hreflangs(website)
    locales(website).uniq & all_locales_with_translations(website).uniq
  end

  def copy!(options = {})
    npf = self.dup
    if options[:parent_id]
      npf.parent_id = options[:parent_id]
    else
      npf.hide_from_navigation = true
    end
    npf.family_photo = family_photo if family_photo.present?
    npf.family_banner = family_banner if family_banner.present?
    npf.title_banner = title_banner if title_banner.present?
    npf.save

    npf.products = products
    npf.testimonials = testimonials

    features.find_each do |f|
      new_feature = f.dup
      new_feature.featurable = npf
      new_feature.image = f.image if f.image.present?
      new_feature.save
    end

    children.each{ |c| c.copy!(parent_id: npf.id) }

    npf
  end

end

