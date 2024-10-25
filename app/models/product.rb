class Product < ApplicationRecord
  include GeoAlternative
  extend FriendlyId
  friendly_id :slug_candidates

  attr_accessor :old_id
  attribute :skip_touches, :boolean
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
  has_many :specifications, through: :product_specifications
  has_many :specification_groups, through: :specifications
  has_many :artist_products, dependent: :destroy, inverse_of: :product
  has_many :artists, through: :artist_products
  has_many :product_site_elements, -> { order('position') }, dependent: :destroy, inverse_of: :product
  has_many :site_elements, through: :product_site_elements
  has_many :product_promotions, dependent: :destroy, inverse_of: :product
  has_many :promotions, through: :product_promotions
  has_many :product_suggestions, -> { order('position') }, dependent: :destroy
  has_many :product_prices, dependent: :destroy
  has_many :suggested_fors, class_name: "ProductSuggestion", foreign_key: "suggested_product_id", dependent: :destroy
  has_many :faqs
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
  has_many :product_descriptions, dependent: :destroy
  has_many :highlights, -> { order('position') }, as: :featurable, class_name: "Feature", dependent: :destroy
  has_many :product_parts
  has_many :parts, through: :product_parts
  has_many :product_badges, dependent: :destroy
  has_many :badges, through: :product_badges
  has_many :product_accessories
  has_many :accessory_products, through: :product_accessories
  has_many :customizable_attribute_values, dependent: :destroy
  has_many :customizable_attributes, -> { distinct }, through: :customizable_attribute_values
  belongs_to :product_status
  belongs_to :brand, touch: true
  has_many :parent_products # Where this is the child (ie, an e-pedal child of the iStomp)
  has_many :sub_products, -> { order('position') }, class_name: "ParentProduct", foreign_key: "parent_product_id"
  has_many :product_product_filter_values
  has_many :product_filters, through: :product_product_filter_values
  has_many :brand_dealer_rental_products
  has_many :product_case_studies, -> { order('position') }

  after_initialize :set_default_status
  accepts_nested_attributes_for :product_prices, reject_if: proc { |pp| pp['price'].blank? }
  accepts_nested_attributes_for :product_specifications, reject_if: proc { |ps| ps['value'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :product_product_filter_values, reject_if: :reject_filter_value?
  accepts_nested_attributes_for :customizable_attribute_values, reject_if: proc { |cav| cav['value'].blank? }
  accepts_nested_attributes_for :product_videos, reject_if: proc { |pv| pv['youtube_id'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :product_case_studies, reject_if: proc { |pcs| pcs['case_study_slug'].blank? }, allow_destroy: true

  def reject_filter_value?(ppfv)
    (ppfv['string_value'].blank? && ppfv['boolean_value'].blank? && ppfv['number_value'].blank?)
  end

  has_many :content_translations, as: :translatable, foreign_key: "content_id", foreign_type: "content_type"

  monetize :harman_employee_price_cents, :allow_nil => true
  monetize :msrp_cents, :allow_nil => true
  monetize :street_price_cents, :allow_nil => true
  monetize :sale_price_cents, :allow_nil => true
  monetize :cost_cents, :allow_nil => true
  monetize :artist_price_cents, :allow_nil => true

  before_save :set_employee_price
  after_save :touch_families, unless: :skip_touches?

  serialize :previewers, coder: YAML, type: Array
  has_attached_file :background_image
  validates_attachment :background_image, content_type: { content_type: /\Aimage/i }
  validates :name, presence: true
  validates :sap_sku, format: { with: /\A[\w\-\s]*\z/, message: "only allows letters and numbers" }

  scope :not_associated_with_this_site_element, -> (site_element, website) {
    website.products.where.not(id: site_element.products.select(:id))
  }

  scope :not_associated_with_this_software, -> (software, website) {
    website.products.where.not(id: software.products.select(:id))
  }

  scope :not_associated_with_these_products, -> (associated_products, website) {
    product_ids_already_associated_with_this_product = associated_products.map{|associated_product| associated_product.id }
    website.products.where.not(id: product_ids_already_associated_with_this_product)
  }

  scope :not_associated_with_this_product_family, -> (product_family, website) {
    website.products.where.not(id: product_family.products.select(:id))
  }

  scope :not_associated_with_these_parent_products, -> (parent_products, website) {
    parent_product_ids_already_associated_with_this_product = parent_products.map{|parent_product| parent_product.parent_product_id }
    website.products.where.not(id: parent_product_ids_already_associated_with_this_product)
  }

  scope :not_associated_with_this_news_item, -> (news_item, website) {
    self.where(brand_id: news_item.brands.select(:id)).where.not(id: news_item.products.select(:id))
  }

  scope :not_associated_with_this_badge, -> (badge, website) {
    website.products.where.not(id: badge.products.select(:id))
  }

  scope :not_associated_with_this_part, -> (part, website) {
    website.products.where.not(id: part.products.select(:id))
  }

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

  def touch_families
    product_families.each{|pf| pf.touch}
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
      self.brand_id == brand.id || self.product_families.pluck(:brand_id).include?(brand.id)
    rescue
      false
    end
  end

  # Replacing "description" column with external table
  def description_field
    product_descriptions.where(content_name: "description").first_or_initialize
  end

  def description
    description_field.content
  end

  def description=(content)
    d = description_field
    d.content = content
    d.save unless d.new_record?
  end

  # Replacing "features" column with external table
  def features_field
    product_descriptions.where(content_name: "features").first_or_initialize
  end

  def features
    features_field.content
  end

  def features=(content)
    f = features_field
    f.content = content
    f.save unless f.new_record?
  end

  # Replacing "extended_description" column with external table
  def extended_description_field
    product_descriptions.where(content_name: "extended_description").first_or_initialize
  end

  def extended_description
    extended_description_field.content
  end

  def extended_description=(content)
    e = extended_description_field
    e.content = content
    e.save unless e.new_record?
  end

  def current_sub_products
    @current_sub_products ||= sub_products.select{|sub_product| sub_product.product if sub_product.product.product_status.show_on_website?}
  end

  def images_for(destination="product_page")
    product_attachments.select do |pa|
      pa if pa.send("for_#{destination}?")
    end
  end

  def set_default_status
    if self.respond_to?(:product_status_id)
      self.product_status_id ||= 3 #ProductStatus.where("name LIKE '%%production%%'").first
    end
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

  def eol?
    product_status.eol?
  end

  # can this product be registered with us?
  def can_be_registered?
    !!!(self.product_status.not_supported?) && !!(self.product_status.show_on_website?) && !!!(self.product_status.vintage?) && !!!(self.parent_products.size > 0) && !!!self.is_accessory?
  end

  #
  # To determine if a product is an accessory, we check if any of its product families are
  # named something like "accessor". But first, we also check to see if it is a "controller" like
  # a remote foot controller. These are sort-of accessories, but sort-of not. For the sake of
  # product registration foot controllers are not accessories. For
  # navigation of the site, they are. This function excludes foot controllers from accessories.
  #
  def is_accessory?
    return true if self.accessory_to_products.size > 0
    families = self.product_families.map{|pf| pf.tree_names}.join(" ")
    !!!(families.match(/controller/)) ? false : !!(families.match(/accessor/i))
  end

  def is_customizable?
    customizable_attributes.size > 0
  end

  def sample
    @sample ||= self.product_attachments.where("product_media_file_name LIKE '%mp3%'").first
  end

  def photo
    ProductAttachment.where(product_id: self.id, primary_photo: true).first
  end

  def photo=(product_attachment)
    product_attachment.update(primary_photo: true)
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

  # AA 2019-03-18. Removing the condition about p.discontinue? || ... I can't tell what it's for besides slowing us down
  def belongs_to_this_website?(website)
    p = (self.parents.size > 0) ? self.parents.first : self
    p.belongs_to_this_brand?(website)# && (p.discontinued? || !(p.product_families & website.product_families).empty?)
  end

  def related_products
    rp = []
    product_families.find_each do |pf|
      rp += pf.products
    end
    rp.uniq
  end

  # Collection of all the locales where this Product should appear.
  # By definition, it should include ALL locales unless there is one or more
  # limitation specified in the related ProductFamilies
  def locales(website)
    if product_families.size > 0
      @locales ||= product_families.map do |pf|
        pf.find_ultimate_parent.locales(website)
      end.flatten.uniq - locales_where_hidden
    else
      @locales ||= website.list_of_all_locales - locales_where_hidden
    end
  end

  def locales_where_hidden
    hidden_locales.to_s.split(',')
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

  def exclusive_retailer_link
    @exclusive_retailer_link ||= active_retailer_links.select{|orl| orl if orl.exclusive?}.first
  end

  # Collect tabs of info to be displayed on product page.
  # To create a new tab:
  # 1. Add it to this array by appending the brand's "side_tabs" setting
  # 2. Add a corresponding translation in each config/locales YAML file under "product_page"
  # 3. Create a corresponding partial in app/views/products
  #
  def tabs
    @tabs ||= collect_tabs(brand.side_tabs)
  end

  # Collect tabs of info to be displayed on product page.
  # To create a new tab:
  # 1. Add it to this array by appending the brand's "main_tabs" setting
  # 2. Add a corresponding translation in each config/locales YAML file under "product_page"
  # 3. Create a corresponding partial in app/views/products
  #
  def main_tabs
    @main_tabs ||= collect_tabs(brand.main_tabs)
  end

  def collect_tabs(tabs, check_for_content=true)
    tabs.map do |tab|
      ProductTab.new(tab) if !check_for_content || has_content_for?(tab)
    end.compact
  end

  def has_content_for?(tab)
    if self.respond_to?("#{tab}_content_present?")
      return send("#{tab}_content_present?")
    end

    return true if tab == "description" || tab == "support" || tab == "parts_service"

    value = self.send(tab)
    (value.respond_to?(:length) && value.length > 0) || (value.respond_to?(:present?) && value.present?)
  end

  def extended_description_content_present?
    extended_description.present?
  end

  def features_content_present?
    features.size > 15
  end

  def videos_content_present?
    product_videos.select(:id).size > 0
  end

  def documentation_content_present?
    product_documents.size > 0 || current_promotions.size > 0 || viewable_site_elements.size > 0
  end

  def downloads_content_present?
    softwares.size > 0 || executable_site_elements.size > 0 || site_elements.size > 0 || product_documents.size > 0
  end

  def specifications_content_present?
    product_specifications.size > 0
  end

  def specifications_accessories_content
    specification_ids = specifications.where("name like ?","%accessories%").collect(&:id)
    content = product_specifications.where(specification_id:specification_ids).pluck(:value).join(", ")
    content
  end

  def specifications_fg_numbers_content
    specification_ids = specifications.where("name like ?","%fg numbers%").collect(&:id)
    content = product_specifications.where(specification_id:specification_ids).pluck(:value).join(", ")
    content
  end

  def specifications_jitc_status_content
    specification_ids = specifications.where("name like ?","%jitc status%").collect(&:id)
    content = product_specifications.where(specification_id:specification_ids).pluck(:value).join(", ")
    content
  end

  def downloads_and_docs_content_present?
    documentation_content_present? || downloads_content_present?
  end

  def news_content_present?
    current_news.size > 0
  end

  def recommended_accessories_content_present?
    !discontinued? && alternatives.size > 0
  end

  def configuration_tool_content_present?
    external_configuration_tool.present?
  end

  def external_configuration_tool
    config_tool = site_elements.find { |item| item.resource_type.downcase == "configuration tools" && item.external_url.present? }
    config_tool
  end

  def reviews_content_present?
    product_reviews.size > 0
  end

  def news_and_reviews_content_present?
    news_content_present? || reviews_content_present?
  end

  def photometrics_content_present?
    photometric_id.present?
  end

  # Collects those site_elements where the download is software or a zip
  def executable_site_elements
    @executable_site_elements ||= site_elements.where(id: deduped_site_element_ids, is_software: true)
  end

  # Collects those site_elements where the download is PDF or image
  def viewable_site_elements
    @viewable_site_elements ||= site_elements.where(id: deduped_site_element_ids, is_document: true)
  end

  # Collects software site elements
  def software_site_elements
    @software_site_elements ||= site_elements.where(id: deduped_site_element_ids).where("resource_type LIKE '%Software%'")
  end

  def deduped_site_element_ids
    site_elements.select{|s| s.id if latest_version_of_site_element?(s)}
  end

  def latest_version_of_site_element?(site_element)
    site_element == unsorted_site_elements.where(name: site_element.name, language: site_element.language).order(:version).last
  end

  def unsorted_product_site_elements
    @unsorted_product_site_elements ||= ProductSiteElement.where(product_id: id)
  end

  def unsorted_site_elements
    @unsorted_site_elements ||= SiteElement.where(
      id: unsorted_product_site_elements.pluck(:site_element_id),
      link_status: ["", nil, "200"]
    )
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
    self.send(:link_name_method)
  end

  def link_name_method
    :name
  end

  # Alias for search results content_preview
  def content_preview
    self.send(content_preview_method)
  end

  def content_preview_method
    :description
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

  def has_custom_css?
    self.custom_css.present?
  end

  # Artists on tour with this product
  def artists_on_tour
    begin
      artist_products.where(on_tour: true).find_each.collect{|ap| ap.artist}.sort{|a,b| a.position <=> b.position}
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
    promotions.where(["start_on IS NOT NULL AND start_on <= ? AND (end_on >= ? OR end_on IS NULL OR length(end_on) = 0)", Date.today, Date.today]).order("start_on")
  end

  def first_promo_with_price_adjustment
    product_promotions.
      where(promotion_id: current_promotions.where(show_recalculated_price: true).pluck(:id)).
      where("discount > 0").first
  end

  # Pick only those artists who are approved
  def approved_artists
    artists.where("approver_id > 0 AND artist_tier_id > 0").order("artist_tier_id ASC, name ASC")
  end

  # Currently active software
  def active_softwares(locale = I18n.default_locale.to_s, website = brand.default_website)
    softwares.where("active = true and category <> 'firmware'").select{|s| s if s.locales(website).include?(locale)}
  end

  # This method is to accommodate Soundcraft's product page needs
  def active_softwares_soundcraft(locale = I18n.default_locale.to_s, website = brand.default_website)
    softwares.where(active: true).select{|s| s if s.locales(website).include?(locale)}
  end

  # Currently active firmware
  def active_firmwares(locale = I18n.default_locale.to_s, website = brand.default_website)
    f = softwares.where(active: true, category: "firmware").select{|s| s if s.locales(website).include?(locale)}
    if website.firmware_page && firmware_name.present?
      firmware_name.split("|").each do |fname|
        f << Software.new(
          name: fname,
          version: MartinFirmwareService.firmware_version(fname.gsub(/ \- Firmware/, '')),
          active: true,
          category: "firmware",
          updated_at: MartinFirmwareService.get_update_date,
          link: website.firmware_page
        )
      end
    end
    f
  end

  def case_studies
    ProductCaseStudy.where(product_id: self.id).order("position").pluck(:case_study_slug).map do |case_study_slug|
      CaseStudy.find_by_slug_and_website_or_brand(case_study_slug, brand)
    end
  end

  # Collects suggested products
  def suggested_products
    sp = []
    sp = self.product_suggestions.collect{|ps| ps.suggested_product}[0,2]
    possibilities = (self.brand.current_products - sp - [self])
    until sp.size >= 2 || possibilities.size == 0
      sp << possibilities[rand(possibilities.size)]
    end
      possibilities -= sp
    sp
  end

  # Suggested alternatives (usually for a discontinued product)
  def alternatives
    self.product_suggestions.collect{|ps| ps.suggested_product}
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

  def safety_documents
    @safety_documents ||= product_documents.where("document_type LIKE '%safety%'").where(show_on_public_site: true)
  end

  def safety_site_elements
    @safety_site_elements ||= site_elements.where("resource_type LIKE '%safety%' OR resource_type LIKE '%compliance%'").where(is_document: true)
  end

  def nonsafety_documents
    @nonsafety_documents ||= product_documents.where("document_type NOT LIKE '%safety%'").where(link_status: ["", nil, "200"], show_on_public_site: true)
  end

  # Just take the first one
  def get_started_page
    get_started_pages.first
  end

  def has_full_width_banner?
    full_width_banners.size > 0
  end

  def full_width_banners
    product_attachments.where(show_as_full_width_banner: true)
  end

  def ungrouped_product_specifications
    product_specifications.
      includes(:specification).
      where(specification: { specification_group_id: ["", nil]}).
      reorder("product_specifications.position")
  end

  def specification_ids
    product_specifications.select(:specification_id)
  end

  def all_related_downloads(locale = I18n.default_locale.to_s, website = brand.default_website)
    @all_related_downloads = viewable_site_elements + executable_site_elements + active_softwares(locale, website) + active_firmwares(locale, website)
  end

  def accessories
    accessory_products.includes(:product_status).where(product_statuses: {show_on_website: true})
  end

  def product_accessories_where_this_is_the_accessory
    ProductAccessory.where(accessory_product_id: self.id)
  end

  def accessory_to_products
    Product.where(id: product_accessories_where_this_is_the_accessory.pluck(:product_id))
  end

  # Primary family is really just the first related product family
  # which is active in the current locale. Used for breadcrumb schema
  # and breadcrumb navigation.
  def primary_family(website)
    pffcl = product_families_for_current_locale(website)
    pffcl.size > 0 ? pffcl.first : product_families.first
  end

  def product_families_for_current_locale(website)
    product_families.where(brand_id: website.brand_id).select{|pf| pf if pf.locales(website).include?(I18n.locale.to_s)}
  end

  def product_family_tree
    product_families.map{|pf| [pf, pf.family_tree]}.flatten.uniq.reject{|i| i.blank?}
  end

  def parent_families_with_filters
    product_families.map{|pf| pf.self_and_parents_with_filters}.flatten.uniq
  end

  def available_product_filters
    parent_families_with_filters.map{|pf| pf.product_filters}.flatten.uniq
  end

  def available_product_filter_values
    available_product_filters.map do |product_filter|
      if self.product_filters.include?(product_filter)
        self.product_product_filter_values.where(product_filter: product_filter)
      else
        ProductProductFilterValue.new(
          product: self,
          product_filter: product_filter
        )
      end
    end
  end

  def filter_value(product_filter)
    product_product_filter_values.where(product_filter: product_filter).first_or_initialize.value
  end

  def parent_families_with_customizable_attributes
    product_families.map{|pf| pf.self_and_parents_with_customizable_attributes}.flatten.uniq
  end

  def available_customizable_attributes
    parent_families_with_customizable_attributes.map{|pf| pf.customizable_attributes}.flatten.uniq
  end

  def available_customizable_attribute_values
    available_customizable_attributes.map do |customizable_attribute|
      if customizable_attributes.include?(customizable_attribute)
        customizable_attribute_values.where(customizable_attribute: customizable_attribute) +
          build_customizable_attribute_values(customizable_attribute, 2)
      else
        build_customizable_attribute_values(customizable_attribute, 4)
      end
    end
  end

  def build_customizable_attribute_values(customizable_attribute, number)
    customizable_attribute_values.build(
      number.times.map do
        { customizable_attribute: customizable_attribute }
      end
    )
  end

  def user_guides
    ug = []
    ug << product_documents.where(document_type: "owners_manual").map{|pd| pd.document.url}
    ug << viewable_site_elements.where("resource_type LIKE '%User Guide%' or resource_type LIKE '%Manual%'").map{|se| "https://#{se.brand.default_website.url}#{se.url}"}
    ug
  end

  def spec_sheets
    ss = []
    ss << product_documents.where(document_type: ["spec_sheet", "cut_sheet"]).map{|pd| pd.document.url}
    ss << viewable_site_elements.where("resource_type LIKE '%Spec Sheet%' or resource_type LIKE '%Data Sheet%'").map{|se| "https://#{se.brand.default_website.url}#{se.url}"}
    ss
  end

  def best_guess_spec_value(name)
    specs = product_specifications.where(specification_id: Specification.send("#{name}_specs").pluck(:id))
    if specs.length > 0
      specs.first.value
    end
  end

  # Merge the list of locales where this Product  should appear with
  # available translations plus our usual English locales
  # Then remove the current locale
  def other_locales_with_translations(website)
    all_locales_with_translations(website) - [I18n.locale.to_s]
  end

  def all_locales_with_translations(website)
    (locales(website) & (content_translations.pluck(:locale).uniq + ["en", "en-US"]))
  end

  def hreflangs(website)
    locales(website) & all_locales_with_translations(website)
  end

  def copy!
    new_product = self.dup
    new_product.product_status = ProductStatus.where(show_on_website: false).first
    new_product.name += " COPY"
    new_product.save

    new_product.product_families = product_families
    new_product.news = news
    new_product.softwares = softwares
    new_product.site_elements = site_elements
    new_product.promotions = promotions
    new_product.artists = artists
    new_product.market_segments = market_segments
    new_product.badges = badges
    new_product.parts = parts
    new_product.accessory_products = accessory_products

    product_attachments.find_each do |pa|
      new_pa = pa.dup
      new_pa.product_attachment = pa.product_attachment
      new_pa.product_media = pa.product_media
      new_pa.product = new_product
      new_pa.save
    end

    product_specifications.find_each do |ps|
      new_ps = ps.dup
      new_ps.product = new_product
      new_ps.save
    end

    product_descriptions.find_each do |pd|
      new_pd = pd.dup
      new_pd.product = new_product
      new_pd.save
    end

    product_product_filter_values.find_each do |ppfv|
      new_ppfv = ppfv.dup
      new_ppfv.product = new_product
      new_ppfv.save
    end

    new_product
  end

end
