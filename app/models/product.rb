class Product < ActiveRecord::Base
  has_one :product_introduction
  has_many :tones
  has_many :product_family_products, dependent: :destroy
  has_many :product_families, through: :product_family_products
  has_many :product_attachments, order: :position
  has_many :online_retailer_links, dependent: :destroy
  has_many :product_review_products, dependent: :destroy
  has_many :product_reviews, through: :product_review_products
  has_many :news_products, dependent: :destroy
  has_many :news, through: :news_products
  has_many :product_documents, order: "document_type, document_file_name", dependent: :destroy
  has_many :product_softwares, dependent: :destroy
  has_many :softwares, through: :product_softwares
  has_many :product_specifications, order: :position, dependent: :destroy
  has_many :artist_products, dependent: :destroy, inverse_of: :product
  has_many :artists, through: :artist_products
  has_many :product_site_elements, dependent: :destroy, inverse_of: :product
  has_many :site_elements, through: :product_site_elements
  has_many :product_promotions, dependent: :destroy
  has_many :product_suggestions, dependent: :destroy, order: :position
  has_many :suggested_fors, class_name: "ProductSuggestion", foreign_key: "suggested_product_id", dependent: :destroy
  has_many :promotions, through: :product_promotions
  has_many :tone_library_patches, 
    include: :tone_library_song, 
    order: "tone_library_songs.artist_name, tone_library_songs.title"
  has_many :faqs
  has_many :product_amp_models, dependent: :destroy
  has_many :amp_models, through: :product_amp_models
  has_many :product_cabinets, dependent: :destroy
  has_many :cabinets, through: :product_cabinets
  has_many :product_effects, dependent: :destroy
  has_many :effects, through: :product_effects
  has_many :clinic_products
  has_many :clinics, through: :clinic_products
  has_many :product_training_classes, dependent: :destroy
  has_many :training_classes, through: :product_training_classes
  has_many :product_training_modules, dependent: :destroy, order: :position
  has_many :training_modules, through: :product_training_modules
  has_many :product_audio_demos, dependent: :destroy
  has_many :audio_demos, through: :product_audio_demos
  belongs_to :product_status
  belongs_to :brand, touch: true
  has_many :parent_products # Where this is the child (ie, an e-pedal child of the iStomp)
  has_many :parents, through: :parent_products
  has_many :sub_products, class_name: "ParentProduct", foreign_key: "parent_product_id", order: :position
  after_initialize :set_default_status
  
  serialize :previewers, Array
  has_attached_file :background_image,
    path: ":rails_root/public/system/:attachment/:id/:style/:filename",
    url: "/system/:attachment/:id/:style/:filename"

  validates_presence_of :name, :product_status_id
  has_friendly_id :name, use_slug: true, approximate_ascii: true, max_length: 100
  
  define_index do
    indexes :name
    indexes :keywords
    indexes :description
    indexes :short_description
  end
  
  def belongs_to_this_brand?(website)
    begin
      self.brand_id == website.brand_id || self.product_families.collect{|pf| pf.brand_id}.include?(website.brand_id)
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
    all.select{|p| p if !p.product_status.is_discontinued? && p.belongs_to_this_brand?(website)}.sort{|a,b| a.name.downcase <=> b.name.downcase}
  end
  
  def self.all_for_website(website)
    all.select{|p| p if p.product_status.show_on_website && p.belongs_to_this_brand?(website)}.sort{|a,b| a.name.downcase <=> b.name.downcase}
  end

  def self.all_for_website_registration(website)
    p = []
    all.select{|p| p if p.product_status.show_on_website && p.belongs_to_this_brand?(website)}.sort{|a,b| a.name.downcase <=> b.name.downcase}.each do |prod|
      p << prod if prod.can_be_registered?
    end
    p
  end
  
  def self.discontinued(website)
    all.select{|p| p if p.product_status.is_discontinued? && p.belongs_to_this_brand?(website)}.sort{|a,b| a.name.downcase <=> b.name.downcase}
  end
  
  def self.non_supported(website)
    all.select{|p| p if p.product_status.not_supported? && p.belongs_to_this_brand?(website)}.sort{|a,b| a.name.downcase <=> b.name.downcase}
  end
  
  # Find those which are on tour with an Artist
  def self.on_tour(website)
    all.select{|product| product if product.artists_on_tour.size > 0 && product.belongs_to_this_brand?(website)}
  end
  
  def in_production?
    product_status.in_production?
  end
  
  def discontinued?
    product_status.is_discontinued?
  end
  
  # can this product be registered with us?
  def can_be_registered?
    !!!(self.product_status.not_supported?) && !!(self.in_production?) && !!!(self.parent_products.size > 0)
  end

  def sample
    @sample ||= self.product_attachments.where("product_media_file_name LIKE '%mp3%'").first
  end
  
  def photo
    ProductAttachment.find_by_product_id_and_primary_photo(self.id, true)
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
    self.product_status.show_on_website? && self.belongs_to_this_brand?(website)
  end
  
  def related_products
    rp = []
    product_families.collect.each do |pf|
      rp += pf.products
    end
    rp.uniq
  end

  def active_retailer_links(random=true)
    arl = self.online_retailer_links.select{|orl| orl if orl.online_retailer.active}
    if random 
      arl = arl.sort_by{rand}
    end
    arl
  end
  
  # Collect tabs of info to be displayed on product page.
  # To create a new tab:
  # 1. Add it to this array
  # 2. Add a corresponding translation in each config/locales YAML file under "product_page"
  # 3. Create a corresponding partial in app/views/products
  #
  def tabs
    r = []
    # r << ProductTab.new(key: "details") if !self.extended_description.blank? # (moved to main content area)
    unless self.package_tabs.size > 0
      r << ProductTab.new("features") if self.features && self.features.size > 15 && self.brand.side_tabs.include?("features")
    end
    r << ProductTab.new("specifications") if self.product_specifications.size > 0 && self.brand.side_tabs.include?("specifications")
    r << ProductTab.new("documentation") if self.product_documents.size > 0 && self.brand.side_tabs.include?("documentation")
    r << ProductTab.new("training_modules") if self.training_modules.size > 0 && self.brand.side_tabs.include?("training_modules")
    r << ProductTab.new("downloads") if (self.softwares.size > 0 || self.site_elements.size > 0) && self.brand.side_tabs.include?("downloads")
    r << ProductTab.new("reviews") if (self.product_reviews.size > 0 || self.artists.size > 0) && self.brand.side_tabs.include?("reviews")
    r << ProductTab.new("artists") if self.artists.size > 0 && self.brand.side_tabs.include?("artists")
    r << ProductTab.new("tones") if self.tone_library_patches.size > 0 && self.brand.side_tabs.include?("tones")
    r << ProductTab.new("news_and_reviews") if self.news_and_reviews.size > 0 && self.brand.side_tabs.include?("news_and_reviews")
    r << ProductTab.new("news") if self.news.size > 0 && self.brand.side_tabs.include?("news")
    r << ProductTab.new("support") if self.brand.side_tabs.include?("support")
    r
  end

  # Collect main content area tabs
  # All these tabs methods are prime candidates for refactoring. They've grown
  # to be kind of verbose and redundant
  def main_tabs
    r = []
    r << ProductTab.new("description")
    r << ProductTab.new("extended_description") if !self.extended_description.blank? && self.brand.main_tabs.include?("extended_description")
    r << ProductTab.new("features") if self.features && self.features.size > 15 && self.brand.main_tabs.include?("features")
    r << ProductTab.new("specifications") if self.product_specifications.size > 0 && self.brand.main_tabs.include?("specifications")
    r << ProductTab.new("documentation") if self.product_documents.size > 0 && self.brand.main_tabs.include?("documentation")
    r << ProductTab.new("training_modules") if self.training_modules.size > 0 && self.brand.main_tabs.include?("training_modules")
    r << ProductTab.new("downloads_and_docs") if (self.softwares.size > 0 || self.product_documents.size > 0 || self.site_elements.size > 0) && self.brand.main_tabs.include?("downloads_and_docs")
    r << ProductTab.new("reviews") if (self.product_reviews.size > 0 || self.artists.size > 0) && self.brand.main_tabs.include?("reviews")
    r << ProductTab.new("artists") if self.artists.size > 0 && self.brand.main_tabs.include?("artists")
    r << ProductTab.new("tones") if self.tone_library_patches.size > 0 && self.brand.main_tabs.include?("tones")
    r << ProductTab.new("news_and_reviews") if self.news_and_reviews.size > 0 && self.brand.main_tabs.include?("news_and_reviews")
    r << ProductTab.new("news") if self.news.size > 0 && self.brand.main_tabs.include?("news")
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

  # Pretty awful hack to see if a custom tab name exists for the given tab "name".
  # Really only works with "features" for now.
  def rename_tab(name)
    if name == 'features' && !self.features_tab_name.blank?
      self.features_tab_name
    end
  end

  # Combines related News and ProductReview for this Product into one list
  def news_and_reviews
    (self.news + self.product_reviews).sort!{|a,b| b.created_at <=> a.created_at}
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
    self.promotions.where(["show_start_on <= ? AND show_end_on >= ?", Date.today, Date.today]).order("start_on")
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
  
end
