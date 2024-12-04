class Brand < ApplicationRecord
  include WaveReport
  extend FriendlyId
  friendly_id :name

  has_many :product_families
  has_many :market_segments, -> { order("created_at ASC") }
  has_many :online_retailer_links, -> { where("active = 1").order("RAND()") }
  has_many :brand_dealers, dependent: :destroy
  has_many :dealers, through: :brand_dealers
  has_many :brand_news, dependent: :destroy
  has_many :news, through: :brand_news
  has_many :faq_categories
  has_many :pages
  has_many :installations
  has_many :promotions
  has_many :service_centers
  has_many :softwares
  has_many :artist_brands, dependent: :destroy
  has_many :artists, through: :artist_brands
  has_many :warranty_registrations
  has_many :brand_distributors
  has_many :distributors, through: :brand_distributors
  has_many :websites
  has_many :settings
  has_many :site_elements
  has_many :training_modules
  has_many :training_courses
  has_many :training_classes, through: :training_courses
  has_many :pricing_types, -> { order('pricelist_order') }
  has_many :us_rep_regions
  has_many :us_reps, through: :us_rep_regions
  has_many :us_regions, -> { order('name') }, through: :us_rep_regions
  has_many :signups
  has_many :get_started_pages
  has_many :events
  has_many :brand_solutions, dependent: :destroy
  has_many :solutions, through: :brand_solutions
  has_many :contact_messages
  has_many :sales_regions
  has_many :testimonials
  has_many :specification_for_comparisons, class_name: "BrandSpecificationForComparison"
  has_attached_file :logo,
    styles: { large: "640x480",
      medium: "480x360",
      small: "240x180",
      thumb: "100x100",
      title: "86x86",
      tiny: "64x64",
      tiny_square: "64x64#"
    }
  validates_attachment :logo, content_type: { content_type: /\Aimage/i }

  #after_initialize :dynamic_methods
  after_update :update_products
  after_touch :touch_websites

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def update_products
    begin
      if self.saved_change_to_attribute?(:live_on_this_platform) && live_on_this_platform?
        self.products.find_each do |p|
          p.more_info_url = nil
          p.save
        end
      end
    rescue
      # oh well.
    end
  end

  def touch_websites
    websites.each{|w| w.touch }
  end

  def should_generate_new_friendly_id?
    true
  end

  def promotions
    Rails.cache.fetch("#{cache_key_with_version}/promotions", expires_in: 6.hours) do
      product_promos = Promotion.find_by_sql("SELECT DISTINCT promotions.id FROM promotions
                                             INNER JOIN product_promotions ON product_promotions.promotion_id = promotions.id
                                             INNER JOIN products ON products.id = product_promotions.product_id
                                             INNER JOIN product_family_products ON product_family_products.product_id = products.id
                                             INNER JOIN product_families ON product_families.id = product_family_products.product_family_id
                                             WHERE product_families.brand_id = #{self.id}").collect{|p| p.id}.join(", ")
      product_promos_query = (product_promos.blank?) ? "" : " OR id IN (#{product_promos}) "

      Promotion.select("DISTINCT *").where("brand_id = ? #{product_promos_query}", self.id)
    end
  end

  def method_missing(sym, *args)
    super if respond_to_without_attributes?(sym, true)
    self.__send__("value_for", sym, *args)
  end

  # Settings that other brands have, but this brand doesn't have defined.
  def unset_settings
    Setting.unset_for_brand(self).select(:name).distinct.order(Arel.sql("UPPER(name)")).pluck(:name)
  end

  # This should work as a dynamic method, but mailers have troubles
  def support_email
    begin
      self.settings.find_by(name: "support_email").value
    rescue
      "support@harman.com"
    end
  end

  def parts_email
    begin
      self.settings.find_by(name: "parts_email").value
    rescue
      self.support_email
    end
  end

  def rma_email
    begin
      self.settings.find_by(name: "rma_email").value
    rescue
      self.support_email
    end
  end

  def rma_credit_email
    begin
      self.settings.find_by(name: "rma_credit_email").value
    rescue
      self.support_email
    end
  end

  def rma_repair_email
    begin
      self.settings.find_by(name: "rma_repair_email").value
    rescue
      self.support_email
    end
  end

  def custom_shop_email
    begin
      self.settings.find_by(name: "custom_shop_email").value
    rescue
      self.support_email
    end
  end

  # Those brands which should appear on the myharman.com store (via the API)
  def self.for_employee_store
    where(employee_store: true).order(Arel.sql("UPPER(name)"))
  end

  def has_where_to_buy?
    !!(self.has_online_retailers? || self.has_dealers? || self.has_distributors?)
  end

  def default_website
    if !self.default_website_id.blank?
      Website.find(self.default_website_id)
    else
      self.websites.first
    end
  end

  def default_website=(website)
    self.default_website_id = website.id
  end

  def twitter_name
    begin
      if self.value_for('twitter') && tw = self.value_for('twitter').match(/(\w*)$/).to_s
        tw
      else
        false
      end
    rescue
      false
    end
  end

  def current_news
    News.all_for_website(self.default_website)
  end

  # Active software with active products
  def current_softwares
    @current_softwares ||= (softwares.where("active = true and category != 'firmware'").
      joins(:product_softwares).
      where(product_softwares: { product_id: current_product_ids }) + forced_current_softwares).uniq
  end

  # Active firmware with active products
  def current_firmwares
    @current_firmwares ||= (softwares.where(active: true, category: "firmware").
      joins(:product_softwares).
      where(product_softwares: { product_id: current_product_ids }) + forced_current_firmwares).uniq
  end

  # Those software with this flag enabled: activate even if there are no active products
  def forced_current_softwares
    @forced_current_softwares ||= softwares.includes(:brand).where("active = true and active_without_products = true and category != 'firmware'").order(:name)
  end

  # Those firmware with this flag enabled: activate even if there are no active products
  def forced_current_firmwares
    @forced_current_firmwares ||= softwares.includes(:brand).where(active: true, category: "firmware", active_without_products: true).order(:name)
  end

  def current_product_ids(opts={})
    Rails.cache.fetch("#{cache_key_with_version}/current_product_ids/#{opts}", expires_in: 6.hours) do
      prods = product_families.includes(:products).
        where(products: { product_status: ProductStatus.current_ids })
      if opts[:locale].present?
        prods = prods.where("products.hidden_locales IS NULL OR (',' + products.hidden_locales + ',') NOT LIKE '%,#{opts[:locale].to_s},%'")
      end
      prods.pluck("products.id").uniq
    end
  end

  def current_products(opts={})
    Rails.cache.fetch("#{cache_key_with_version}/current_products/#{opts}", expires_in: 6.hours) do
      Product.where(id: current_product_ids(opts))
    end
  end

  def family_product_ids
    Rails.cache.fetch("#{cache_key_with_version}/family_product_ids", expires_in: 6.hours) do
      Product.joins(product_family_products: :product_family).
        where(product_family: { brand_id: self.id } ).
        pluck(:id)
    end
  end

  def family_products
    Product.where(id: family_product_ids).
      order(Arel.sql("UPPER(products.name)"))
  end

  def products
    fp_ids = self.family_product_ids
    if fp_ids.blank?
      Product.where(brand_id: self.id).order(Arel.sql("UPPER(name)"))
    else
      Product.where(brand_id: self.id).or(Product.where(id: fp_ids)).order(Arel.sql("UPPER(name)"))
    end
  end

  def value_for(key, locale=I18n.locale)
    # start with the current, full locale
    locales_to_search = [locale.to_s]

    # add a parent locale if present
    if parent_locale = (I18n.locale.to_s.match(/^(.*)-/)) ? $1 : false # "es-MX" => "es"
      locales_to_search << parent_locale
    end

    # also search empty locales
    locales_to_search += ["", nil]

    found_settings = {}
    self.settings.where(name: key, locale: locales_to_search).each do |ls|
      found_settings[ls.locale] = ls.value
    end

    # merge the locales_to_search with the keys of what was found
    # to basically sort the found keys in order of preference
    matched_locales = locales_to_search & found_settings.keys
    if matched_locales.size > 0
      return found_settings[matched_locales.first]
    end

    return nil
  end

  # The default side tabs to show on product pages. This can be overridden
  # with a setting named side_tabs which is a pipe-separated list of tabs
  def side_tabs
    if tabs = self.value_for("side_tabs")
      tabs = tabs.gsub(/\s/, '')
    else
      tabs = ""
    end
    tabs.split("|")
  end

  def main_tabs
    if tabs = self.value_for("main_tabs")
      tabs = tabs.gsub(/\s/, '')
    else
      tabs = "description|extended_description|audio_demos|features|specifications|documentation|training_modules|downloads|artists|news_and_reviews|support"
    end
    tabs.split("|")
  end

  def admin_actions(num_days=365)
    AdminLog.where(website_id: self.websites.collect{|w| w.id}).where("created_at > ?", num_days.days.ago)
  end

  # For the api, picks a slideshow banner.
  def api_banner_url
    begin
      if default = self.value_for("api_banner_url")
        default
      else
        slides = Setting.slides(self.default_website)
        if slides.size > 1
          slides.sample.slide.url(:original, false)
        else
          nil
        end
      end
    rescue
      ""
    end
  end

  # wrapper to inherit from another brand if necessary
  def us_regions_for_website
    this_brand = (self.us_sales_reps_from_brand_id.present?) ? Brand.find(self.us_sales_reps_from_brand_id) : self
    @us_regions ||= this_brand.us_regions.distinct
  end

  # Figure out the default top domain for this brand
  def domain
    default_website.domain
  rescue
    ""
  end

  # Originally designed for the dbx promo where the site needs to
  # appear hacked every X number of visits. This keeps track of how many
  # times the homepage has been visited using the existing Settings
  # model.
  def increment_homepage_counter
    counter = settings.where(name: 'homepage_counter', setting_type: 'integer').first_or_create
    counter.integer_value ||= 0
    if counter.updated_at.to_date == Date.today
      counter.integer_value += 1
    else
      counter.integer_value = 1
    end
    counter.save
    counter.integer_value
  end

  def new_signups
    signups.where("synced_on IS NULL") + warranty_registrations.where(subscribe: true).where("synced_on IS NULL")
  end

  def faq_categories_with_faqs
    faq_categories.select{|fc| fc if fc.faqs.length > 0 }
  end

  def has_news?
    BrandNews.where(brand_id: self.id).size > 0
  end

  def use_flattened_specs?
    self.use_flattened_specs.present? && !!(self.use_flattened_specs.to_i > 0)
  end

  def upcoming_training_classes
    training_classes.where("start_at >= ?", Date.today).order(:start_at)
  end

  def default_layout_class_for_products
    begin
      @default_layout_class_for_products ||= products.select("layout_class, COUNT(id) as count").group(:layout_class).map do |p|
        [p.count, p.layout_class]
      end.sort_by{|p| p[0]}.reverse.first[1]
    rescue
      "vertical"
    end
  end

  def news_tags
    News.includes(:brand_news).where(brand_news: { brand_id: self.id } ).tag_counts
  end

  def bad_site_elements
    site_elements.where.not(link_status: ["", nil, "200"])
  end

  def recent_uploads
    site_elements
      .where(show_on_public_site: true)
      .order("created_at DESC")
      .limit(40).select { |se| se if se.current_products.size > 0 }
  end

  def update_current_product_counts
    product_families.where(parent_id: nil).each do |parent_family|
      parent_family.locales(self.default_website).each do |this_locale|
        I18n.locale = this_locale
        parent_family.descendants.each{|d| d.update_current_product_counts_for_locale(this_locale)}
        parent_family.update_current_product_counts_for_locale(this_locale)
      end
    end
  end
  handle_asynchronously :update_current_product_counts

end
