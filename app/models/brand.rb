class Brand < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name

  has_many :product_families
  has_many :market_segments, -> { order("created_at ASC") }
  has_many :online_retailer_links, -> { where("active = 1").order("RAND()") }
  has_many :brand_dealers, dependent: :destroy
  has_many :dealers, through: :brand_dealers
  has_many :news
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
  has_many :training_classes
  has_many :pricing_types, -> { order('pricelist_order') }
  has_many :brand_toolkit_contacts, -> { order('position').includes(:user) }
  has_many :us_rep_regions
  has_many :us_reps, through: :us_rep_regions
  has_many :us_regions, -> { order('name') }, through: :us_rep_regions
  has_many :signups
  has_many :tweets, -> { order("posted_at DESC") }
  has_many :get_started_pages
  has_many :events
  has_many :brand_solutions, dependent: :destroy
  has_many :solutions, through: :brand_solutions
  has_attached_file :logo, {
    styles: { large: "640x480",
      medium: "480x360",
      small: "240x180",
      thumb: "100x100",
      title: "86x86",
      tiny: "64x64",
      tiny_square: "64x64#"
    }}.merge(S3_STORAGE)
  validates_attachment :logo, content_type: { content_type: /\Aimage/i }

  after_initialize :dynamic_methods
  after_update :update_products

  validates :name, presence: true, uniqueness: true

  def update_products
    begin
    if live_on_this_platform_changed? && live_on_this_platform?
      self.products.each do |p|
        p.more_info_url = nil
        p.save
      end
    end
    rescue
      # oh well.
    end
  end

  def should_generate_new_friendly_id?
    true
  end

  def news
    # First, select news story IDs with a product associated with this brand...
    product_news = News.find_by_sql("SELECT DISTINCT news.id FROM news
      INNER JOIN news_products ON news_products.news_id = news.id
      INNER JOIN products ON products.id = news_products.product_id
      INNER JOIN product_family_products ON product_family_products.product_id = products.id
      INNER JOIN product_families ON product_families.id = product_family_products.product_family_id
      WHERE product_families.brand_id = #{self.id}
      ORDER BY post_on DESC").collect{|p| p.id}.join(", ")
    product_news_query = (product_news.blank?) ? "" : " OR id IN (#{product_news}) "

    # Second, add in those stories associated with the brand only (no products linked)
    News.select("DISTINCT *").where("brand_id = ? #{product_news_query}", self.id).order("post_on DESC")
  end

  # Dynamically create methods based on this Brand's settings.
  # This is a smarter alternative to using method_missing
  def dynamic_methods
    self.settings.each do |meth|
      unless self.methods.include?(meth.name.to_sym) # exclude methods already defined in the class
        (class << self; self; end).class_eval do
          define_method meth.name.to_sym do |*args|
            self.__send__("value_for", meth.name, *args)
          end
        end
      end
    end
  end

  # Settings that other brands have, but this brand doesn't have defined.
  def unset_settings
    Setting.where.not(
      brand_id: self.id,
      name: self.settings.pluck(:name),
      setting_type: ["slideshow frame", "homepage feature"]
    ).order("UPPER(name)").pluck(:name).uniq
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

  # Those brands which should appear on the myharman.com store (via the API)
  def self.for_employee_store
    where(employee_store: true).order("UPPER(name)") || where(name: ["DigiTech", "Lexicon", "dbx", "DOD"])
  end

  # Those brands which should appear on the marketing toolkits
  def self.for_toolkit
    where(toolkit: true).order("UPPER(name)").includes(:websites)
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

  def self.pull_tweets
    all.each{|b| b.pull_tweets if b.twitter_name}
  end

  def pull_tweets
    Tweet.pull_tweets(self)
  end

  def recent_tweets(num=6)
    tweets.limit(num)
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
    @current_softwares ||= (softwares.where(active: true).
      joins(:product_softwares).
      where(product_softwares: { product_id: current_product_ids }) + forced_current_softwares).uniq
  end

  # Those software with this flag enabled: activate even if there are no active products
  def forced_current_softwares
    @forced_current_softwares ||= softwares.includes(:brand).where(active: true, active_without_products: true).order(:name)
  end

  def current_product_ids
    product_families.includes(:products).
      where(products: { product_status: ProductStatus.current_ids }).
      pluck("products.id").uniq
  end

  def current_products
    Product.where(id: current_product_ids)
  end

  # Special selection of products just for the toolkit
  def toolkit_products
    products.select{|p| p if p.show_on_toolkit? }.sort_by{|p| p.created_at}.reverse
  end

  def family_products
    p = []
    product_families.includes(:products).each do |pf|
      p += pf.products
    end
    p.sort{|a,b| a.name.downcase <=> b.name.downcase}
  end

  def products
    fp = self.family_products.collect{|p| p.id}.join(', ')
    if fp.blank?
      Product.where(brand_id: self.id).order("UPPER(name)")
    else
      Product.select("DISTINCT *").where("brand_id = ? OR id IN (#{fp})", self.id).order("UPPER(name)")
    end
    # Product.find_by_sql("SELECT DISTINCT products.* FROM products
    #   INNER JOIN product_family_products ON product_family_products.product_id = products.id
    #   INNER JOIN product_families ON product_families.id = product_family_products.product_family_id
    #   WHERE products.brand_id = #{self.id} OR product_families.brand_id = #{self.id}").sort{|a,b| a.name.downcase <=> b.name.downcase}
  end

  def value_for(key, locale=I18n.locale)
    s = self.settings.where(name: key)
    setting = s.where(["locale IS NULL OR locale = ?", locale]).first

    # look for locale-specific setting
    s1 = s.where(locale: locale)
    if s1.all.size > 0
      setting = s1.first
    elsif parent_locale = (I18n.locale.to_s.match(/^(.*)-/)) ? $1 : false # "es-MX" => "es"
      s2 = s.where(locale: parent_locale)
      if s2.all.size > 0
        setting = s2.first
      end
    end

    (setting) ? setting.value : nil
  end

  # The default side tabs to show on product pages. This can be overridden
  # with a setting named side_tabs which is a pipe-separated list of tabs
  def side_tabs
    if tabs = self.value_for("side_tabs")
      tabs = tabs.gsub(/\s/, '')
    else
      tabs = "features|specifications|documentation|training_modules|downloads|artists|tones|news_and_reviews|support"
    end
    tabs.split("|")
  end

  def main_tabs
    if tabs = self.value_for("main_tabs")
      tabs = tabs.gsub(/\s/, '')
    else
      tabs = "description|extended_description|audio_demos|features|specifications"
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

  def toolkit_contacts
    brand_toolkit_contacts.map{|btc| btc.user}
  end

  # wrapper to inherit from another brand if necessary
  def us_regions_for_website
    this_brand = (self.us_sales_reps_from_brand_id.present?) ? Brand.find(self.us_sales_reps_from_brand_id) : self
    @us_regions = this_brand.us_regions
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
    News.where(brand_id: self.id).count > 0
  end

end
