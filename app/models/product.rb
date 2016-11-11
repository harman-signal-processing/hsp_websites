class Product < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates

  has_one :product_introduction
  has_many :product_family_products, dependent: :destroy
  has_many :product_families, through: :product_family_products
  has_many :market_segment_product_families, through: :product_families
  has_many :market_segments, through: :market_segment_product_families
  has_many :product_attachments, -> { order('position') }
  has_many :online_retailer_links, dependent: :destroy
  has_many :product_review_products, dependent: :destroy
  has_many :product_reviews, through: :product_review_products
  has_many :news_products, dependent: :destroy
  has_many :news, through: :news_products
  has_many :product_documents, -> { order("position, document_type, document_file_name") }, dependent: :destroy
  has_many :product_softwares, -> { order("software_position") }, dependent: :destroy
  has_many :softwares, through: :product_softwares
  has_many :product_specifications, -> { order('position') }, dependent: :destroy
  has_many :artist_products, dependent: :destroy, inverse_of: :product
  has_many :artists, through: :artist_products
  has_many :product_site_elements, dependent: :destroy, inverse_of: :product
  has_many :site_elements, through: :product_site_elements
  has_many :product_promotions, dependent: :destroy
  has_many :product_suggestions, -> { order('position') }, dependent: :destroy
  has_many :product_prices, dependent: :destroy
  has_many :suggested_fors, class_name: "ProductSuggestion", foreign_key: "suggested_product_id", dependent: :destroy
  has_many :promotions, through: :product_promotions
  has_many :tone_library_patches, -> { order("tone_library_songs.artist_name, tone_library_songs.title").includes(:tone_library_song) }
  has_many :faqs
  has_many :product_amp_models, dependent: :destroy
  has_many :amp_models, through: :product_amp_models
  has_many :product_cabinets, dependent: :destroy
  has_many :cabinets, through: :product_cabinets
  has_many :product_effects, dependent: :destroy
  has_many :effects, through: :product_effects
  has_many :product_training_classes, dependent: :destroy
  has_many :training_classes, through: :product_training_classes
  has_many :product_training_modules, -> { order('position') }, dependent: :destroy
  has_many :training_modules, through: :product_training_modules
  has_many :product_audio_demos, dependent: :destroy
  has_many :audio_demos, through: :product_audio_demos
  has_many :get_started_page_products, dependent: :destroy
  has_many :get_started_pages, through: :get_started_page_products
  has_many :product_videos, -> { order('position') }, dependent: :destroy
  has_many :product_solutions, dependent: :destroy
  has_many :solutions, through: :product_solutions
  belongs_to :product_status
  belongs_to :brand, touch: true
  has_many :parent_products # Where this is the child (ie, an e-pedal child of the iStomp)
  has_many :sub_products, -> { order('position') }, class_name: "ParentProduct", foreign_key: "parent_product_id"
  after_initialize :set_default_status
  accepts_nested_attributes_for :product_prices, reject_if: :all_blank

  after_save :translate

  monetize :harman_employee_price_cents, :allow_nil => true
  monetize :msrp_cents, :allow_nil => true
  monetize :street_price_cents, :allow_nil => true
  monetize :sale_price_cents, :allow_nil => true
  monetize :cost_cents, :allow_nil => true
  monetize :artist_price_cents, :allow_nil => true

  before_save :set_employee_price

  serialize :previewers, Array
  has_attached_file :background_image
  validates_attachment :background_image, content_type: { content_type: /\Aimage/i }
  validates :name, presence: true
  validates :product_status_id, presence: true
  validates :sap_sku, format: { with: /\A[\w\-\s]*\z/, message: "only allows letters and numbers" }

  def slug_candidates
    [
      :formatted_name,
      [:brand_name, :formatted_name],
      [:brand_name, :formatted_name, :sap_sku],
      [:formatted_name, :short_description],
      [:brand_name, :formatted_name, :short_description]
    ]
  end

  def brand_name
    self.brand.name
  end

  def name_with_brand
    "#{formatted_name} (#{brand_name})"
  end

  # just for slug generation
  def formatted_name
    @formatted_name ||= self.name.gsub(/\s?\+/, ' plus')
  end

  def should_generate_new_friendly_id?
    true
  end

  def set_employee_price
    if self.cost_cents.present? && self.cost_cents > 0
      if ENV['EMPLOYEE_PRICING_PERCENT_OF_COST']
        self.harman_employee_price_cents = self.cost_cents * ENV['EMPLOYEE_PRICING_PERCENT_OF_COST'].to_f
      end
    end
  end

  def artist_price_cents
    if self.cost_cents.present? && self.cost_cents > 0
      if ENV['ARTIST_PRICING_PERCENT_OF_COST'].to_f > 0.0
        self.cost_cents * ENV['ARTIST_PRICING_PERCENT_OF_COST'].to_f
      end
    end
  end

  def belongs_to_this_brand?(brand)
    brand = brand.brand if brand.is_a?(Website) # if a Website is passed in instead of a Brand
    begin
      self.brand_id == brand.id || self.product_families.collect{|pf| pf.brand_id}.include?(brand.id)
    rescue
      false
    end
  end

  def current_sub_products
    @current_sub_products ||= sub_products.select{|sub_product| sub_product.product if sub_product.product.product_status.show_on_website?}
  end

  def images_for(destination="product_page")
    attachments = []
    self.product_attachments.each do |pa|
      attachments << pa if eval("pa.for_#{destination}?")
    end
    attachments
  end

  def set_default_status
    self.product_status_id ||= 3 #ProductStatus.where("name LIKE '%%production%%'").first
  end

  def self.non_discontinued(website)
    order(:name).includes(:product_status, :product_families).select{|p| p if !p.product_status.is_discontinued? && p.belongs_to_this_brand?(website)}.sort{|a,b| a.name.downcase <=> b.name.downcase}
  end

  def self.all_for_website(website, included_objects=[])
    included_objects += [:product_status, :product_families]
    order(:name).includes(included_objects).select{|p| p if p.product_status.show_on_website && p.belongs_to_this_brand?(website)}.sort{|a,b| a.name.downcase <=> b.name.downcase}
  end

  def self.all_for_website_registration(website)
    p = []
    order(:name).includes(:product_status, :product_families).select{|prd| prd if prd.belongs_to_this_brand?(website)}.sort{|a,b| a.name.downcase <=> b.name.downcase}.each do |prod|
      p << prod if prod.can_be_registered?
    end
    p
  end

  def self.discontinued(website, included_objects=[])
    included_objects += [:product_status, :product_families]
    order(:name).includes(included_objects).select{|p| p if p.product_status.is_discontinued? && p.belongs_to_this_brand?(website)}.sort{|a,b| a.name.downcase <=> b.name.downcase}
  end

  def self.non_supported(website)
    order(:name).includes(:product_status, :product_families).select{|p| p if p.product_status.not_supported? && p.belongs_to_this_brand?(website)}.sort{|a,b| a.name.downcase <=> b.name.downcase}
  end

  def self.repairable(website)
    all_for_website(website) - non_supported(website) - website.vintage_products
  end

  # Find those which are on tour with an Artist
  def self.on_tour(website)
    order(:name).includes(:product_status, :product_families).select{|product| product if product.artists_on_tour.size > 0 && product.belongs_to_this_brand?(website)}
  end

  def in_production?
    product_status.in_production?
  end

  def in_development?
    product_status.in_development?
  end

  def discontinued?
    product_status.is_discontinued?
  end

  # can this product be registered with us?
  def can_be_registered?
    !!!(self.product_status.not_supported?) && !!(self.product_status.show_on_website?) && !!!(self.product_status.vintage?) && !!!(self.parent_products.size > 0) && !!!self.is_accessory?
  end

  #
  # To determine if a product is an accessory, we check if any of its product families are
  # named something like "accessor". But first, we also check to see if it is a "controller" like
  # a remote foot controller. These are sort-of accessories, but sort-of not. For the sake of
  # product registration, and toolkit landing pages, foot controllers are not accessories. For
  # navigation of the site, they are. This function excludes foot controllers from accessories.
  #
  def is_accessory?
    families = self.product_families.map{|pf| pf.tree_names}.join(" ")
    !!!(families.match(/controller/)) ? false : !!(families.match(/accessor/i))
  end

  def sample
    @sample ||= self.product_attachments.where("product_media_file_name LIKE '%mp3%'").first
  end

  def photo
    ProductAttachment.where(product_id: self.id, primary_photo: true).first
  end

  def photo=(product_attachment)
    product_attachment.update_attributes(primary_photo: true)
  end

  def primary_photo
    self.photo
  end

  def primary_photo=(product_attachment)
    self.photo = product_attachment
  end

  def show_on_website?(website)
    self.product_status.show_on_website? && self.belongs_to_this_website?(website)
  end

  def belongs_to_this_website?(website)
    p = (self.parents.length > 0) ? self.parents.first : self
    p.belongs_to_this_brand?(website) && (p.discontinued? || !(p.product_families & website.product_families).empty?)
  end

  def show_on_toolkit?
    # comment out '&& self.product_status.show_on_website?' to show un-announced products on toolkit
    !self.virtual_product? #&& self.product_status.show_on_website?
  end

  def related_products
    rp = []
    product_families.collect.each do |pf|
      rp += pf.products
    end
    rp.uniq
  end

  # Selects all ACTIVE retailer links for this Product
  def active_retailer_links
    @active_retailer_links ||= self.online_retailer_links.includes(:online_retailer, :product).select{|orl| orl if orl.online_retailer.active}
  end

  # Randomizes active links, except for preferred
  def randomized_retailer_links
    @randomized_retailer_links ||= (active_retailer_links - preferred_retailer_links).sort_by{rand}
  end

  def preferred_retailer_links
    @preferred_retailer_links ||= active_retailer_links.select{|orl| orl if orl.online_retailer.preferred.to_i > 0}
  end

  # Collect tabs of info to be displayed on product page.
  # To create a new tab:
  # 1. Add it to this array
  # 2. Add a corresponding translation in each config/locales YAML file under "product_page"
  # 3. Create a corresponding partial in app/views/products
  #
  def tabs
    r = []
    begin
      # r << ProductTab.new(key: "details") if !self.extended_description.blank? # (moved to main content area)
      unless self.package_tabs.size > 0
        r << ProductTab.new("features") if self.features && self.features.size > 15 && self.brand.side_tabs.include?("features")
      end
      r << ProductTab.new("videos") if self.product_videos.length > 0 && self.brand.side_tabs.include?("videos")
      r << ProductTab.new("audio_demos") if self.audio_demos.length > 0 && self.brand.side_tabs.include?("audio_demos")
      r << ProductTab.new("specifications") if self.product_specifications.size > 0 && self.brand.side_tabs.include?("specifications")
      r << ProductTab.new("documentation") if (self.product_documents.size > 0 || self.current_and_recently_expired_promotions.size > 0 || self.viewable_site_elements.size > 0) && self.brand.side_tabs.include?("documentation")
      r << ProductTab.new("training_modules") if self.training_modules.size > 0 && self.brand.side_tabs.include?("training_modules")
      r << ProductTab.new("downloads") if (self.softwares.size > 0 || self.executable_site_elements.size > 0) && self.brand.side_tabs.include?("downloads")
      r << ProductTab.new("downloads_and_docs") if (self.softwares.size > 0 || self.product_documents.size > 0 || self.site_elements.size > 0) && self.brand.side_tabs.include?("downloads_and_docs")
      r << ProductTab.new("reviews") if (self.product_reviews.size > 0 || self.artists.size > 0) && self.brand.side_tabs.include?("reviews")
      r << ProductTab.new("artists") if self.artists.size > 0 && self.brand.side_tabs.include?("artists")
      r << ProductTab.new("tones") if self.tone_library_patches.size > 0 && self.brand.side_tabs.include?("tones")
      r << ProductTab.new("news_and_reviews") if self.news_and_reviews.size > 0 && self.brand.side_tabs.include?("news_and_reviews")
      r << ProductTab.new("news") if self.news.size > 0 && self.brand.side_tabs.include?("news")
      r << ProductTab.new("support") if self.brand.side_tabs.include?("support")
    rescue
      # fine, no tabs for you
    end
    r
  end

  # Collect main content area tabs
  # All these tabs methods are prime candidates for refactoring. They've grown
  # to be kind of verbose and redundant
  def main_tabs
    r = []
    r << ProductTab.new("description")
    r << ProductTab.new("extended_description") if !self.extended_description.blank? && self.brand.main_tabs.include?("extended_description")
    r << ProductTab.new("videos") if self.product_videos.length > 0 && self.brand.main_tabs.include?("videos")
    r << ProductTab.new("audio_demos") if self.audio_demos.length > 0 && self.brand.main_tabs.include?("audio_demos")
    r << ProductTab.new("features") if self.features && self.features.size > 15 && self.brand.main_tabs.include?("features")
    r << ProductTab.new("documentation") if (self.product_documents.size > 0 || self.current_and_recently_expired_promotions.size > 0 || self.viewable_site_elements.size > 0) && self.brand.main_tabs.include?("documentation")
    r << ProductTab.new("downloads") if (self.softwares.size > 0 || self.executable_site_elements.size > 0) && self.brand.main_tabs.include?("downloads")
    r << ProductTab.new("specifications") if self.product_specifications.size > 0 && self.brand.main_tabs.include?("specifications")
    r << ProductTab.new("training_modules") if self.training_modules.size > 0 && self.brand.main_tabs.include?("training_modules")
    r << ProductTab.new("downloads_and_docs") if (self.softwares.size > 0 || self.product_documents.size > 0 || self.site_elements.size > 0) && self.brand.main_tabs.include?("downloads_and_docs")
    r << ProductTab.new("news") if self.current_news.size > 0 && self.brand.main_tabs.include?("news")
    r << ProductTab.new("reviews") if (self.product_reviews.size > 0 || self.artists.size > 0) && self.brand.main_tabs.include?("reviews")
    r << ProductTab.new("artists") if self.artists.size > 0 && self.brand.main_tabs.include?("artists")
    r << ProductTab.new("tones") if self.tone_library_patches.size > 0 && self.brand.main_tabs.include?("tones")
    r << ProductTab.new("news_and_reviews") if self.news_and_reviews.size > 0 && self.brand.main_tabs.include?("news_and_reviews")
    r << ProductTab.new("support") if self.brand.main_tabs.include?("support")
    r
  end

  # Same as #tabs, but grouped separately for display purposes
  def package_tabs
    r = []
    if self.has_pedals # (instead of "effects")
      r << ProductTab.new("pedals", self.product_effects.size) if self.product_effects.size > 0
      r << ProductTab.new("amp_models", self.product_amp_models.size) if self.product_amp_models.size > 0
      r << ProductTab.new("cabinets", self.product_cabinets.size) if self.product_cabinets.size > 0
    else
      r << ProductTab.new("amp_models", self.product_amp_models.size) if self.product_amp_models.size > 0
      r << ProductTab.new("cabinets", self.product_cabinets.size) if self.product_cabinets.size > 0
      r << ProductTab.new("effects", self.product_effects.size) if self.product_effects.size > 0
    end
    if r.size > 0
      r.unshift(ProductTab.new("features")) if self.features && self.features.size > 35
    end
    r
  end

  # Collects those site_elements where the download is software or a zip
  def executable_site_elements
    @executable_site_elements ||= site_elements.where(is_software: true)
  end

  # Collects those site_elements where the download is PDF or image
  def viewable_site_elements
    @viewable_site_elements ||= site_elements.where(is_document: true)
  end

  # Pretty awful hack to see if a custom tab name exists for the given tab "name".
  def rename_tab(name)
    if self.respond_to?("#{name}_tab_name")
      n = self.send("#{name}_tab_name")
      n if !n.blank?
    end
  end

  # Combines related News and ProductReview for this Product into one list
  def news_and_reviews
    (self.current_news + self.product_reviews).sort!{|a,b| b.created_at <=> a.created_at}
  end

  def current_news
    self.news.where("post_on <= ?", Date.today)
  end

  # Alias for search results link_name
  def link_name
    self.name
  end

  # Alias for search results content_preview
  def content_preview
    self.description
  end

  # Does this product have a custom background image or color?
  def has_custom_background?
    !self.background_image_file_name.blank? || !self.background_color.blank?
  end

  # Format a CSS background setting value based on this product's custom settings
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

  # Artists on tour with this product
  def artists_on_tour
    begin
      artist_products.where(on_tour: true).all.collect{|ap| ap.artist}.sort{|a,b| a.position <=> b.position}
    rescue
      []
    end
  end

  # A random quote about this Product. Returns an ArtistProduct so you can
  # back-track to get the related Artist
  def random_quote
    self.artist_products.select{|ap| ap unless ap.quote.blank?}.sort_by{rand}.first
  end

  # Promotions which are current and relate to this Product
  def current_promotions
    self.promotions.where(["show_start_on IS NOT NULL AND show_end_on IS NOT NULL AND start_on <= ? AND end_on >= ?", Date.today, Date.today]).order("start_on")
  end

  def current_and_recently_expired_promotions
    self.promotions.where(["show_start_on IS NOT NULL AND show_end_on IS NOT NULL AND show_start_on <= ? AND show_end_on >= ?", Date.today, Date.today]).order("start_on")
  end

  def recently_expired_promotions
    (self.current_and_recently_expired_promotions - self.current_promotions)
  end

  # Pick only those artists who are approved
  def approved_artists
    self.artists.where("approver_id > 0 AND artist_tier_id > 0").order("artist_tier_id ASC, name ASC")
  end

  # Currently active software
  def active_softwares
    self.softwares.where(active: true)
  end

  # Collects suggested products
  def suggested_products
    sp = []
    sp = self.product_suggestions.collect{|ps| ps.suggested_product}[0,2]
    possibilities = (self.brand.current_products - sp - [self])
    until sp.size >= 2 || possibilities.size == 0
      sp << possibilities[rand(possibilities.size)]
      possibilities -= sp
    end
    sp
  end

  # Suggested alternatives (usually for a discontinued product)
  def alternatives
    self.product_suggestions.collect{|ps| ps.suggested_product}
  end

  # If this is an epedal, then it may belong to one or more LabelSheet
  def label_sheets
    l = []
    LabelSheet.all.each{|ls| l << ls if ls.decoded_products.include?(self)}
    l
  end

  def price_for(pricing_type)
    if product_price = product_prices.where(pricing_type_id: pricing_type.id).first
      product_price.price
    else
      nil
    end
  end

  def parents
    @parents ||= parent_products.map{|p| p.parent_product }
  end

  # A hack to exclude epedals from physical product listings
  def virtual_product?
    begin
      istomp = Product.find("istomp")
      self.parents.include?(istomp)
    rescue
      false
    end
  end

  # Translates this record into other languages.
  def translate
    ContentTranslation.auto_translate(self, self.brand)
  end
  handle_asynchronously :translate

  def safety_documents
    @safety_documents ||= product_documents.where("document_type LIKE '%safety%'")
  end

  def nonsafety_documents
    @nonsafety_documents ||= product_documents.where("document_type NOT LIKE '%safety%'")
  end

  # Just take the first one
  def get_started_page
    get_started_pages.first
  end
end
