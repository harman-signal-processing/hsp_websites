class Website < ApplicationRecord
  belongs_to :brand, touch: true
  has_many :website_locales
  validates :url, presence: true, uniqueness: true
  validates :brand_id, presence: true
  validates :folder, presence: true

  def value_for(key, locale=I18n.locale)
    brand.value_for(key, locale)
  end

  def features
    begin
      f = Setting.features(self)
      defaults = f.where(["locale IS NULL or locale = ?", I18n.locale])
      locale_features = nil
      unless I18n.locale == I18n.default_locale
        f1 = f.where(["locale = ?", I18n.locale]) # try "foo_es-MX" (for example)
        if f1.all.size > 0
          locale_features = f1
        elsif parent_locale = (I18n.locale.to_s.match(/^(.*)-/)) ? $1 : false # "es-MX" => "es"
          f2 = f.where(["locale = ?", parent_locale]) # try "foo_es"
          if f2.all.size > 0
            locale_features = f2
          end
        end
      end
      (locale_features) ? locale_features : defaults
    rescue
      []
    end
  end

  def locale
    if self.default_locale && !self.default_locale.blank?
      self.default_locale
    elsif self.brand.default_locale && !self.brand.default_locale.blank?
      self.brand.default_locale
    else
      I18n.default_locale
    end
  end

  def show_locales?
    !!(self.consolidated_locales.size > 1)
  end

  def consolidated_locales
    self.available_locales.collect {|website_locale| website_locale.locale.gsub(/\-+.*$/, "") }.uniq
  end

  def available_locales
    self.website_locales.where(complete: true)
  end

  def list_of_available_locales
    available_locales.collect{|website_locale| website_locale.locale}
  end

  def list_of_all_locales
    self.website_locales.collect{|website_locale| website_locale.locale}
  end

  def has_mac_software?
    begin
      Software.where(brand_id: self.brand_id).where("category LIKE '%mac%' or platform LIKE '%mac%'").all.size > 0
    rescue
      false
    end
  end

  def has_plugins?
    begin
      Software.where(brand_id: self.brand_id).where("category LIKE '%plugin%'").all.size > 0
    rescue
      false
    end
  end

  def brand_name
    @brand_name ||= self.brand.name
  end

  def brand_always_redirect_to_youtube?
    self.brand.always_redirect_to_youtube.nil? ? false : self.brand.always_redirect_to_youtube
  end

  def method_missing(sym, *args)
    super if respond_to_without_attributes?(sym, true)
    if respond_to? sym
      send(sym, *args)
    elsif self.brand.respond_to?(sym)
      variable_name = sym.to_s.gsub(/\W/, "")
      eval("@#{variable_name} ||= self.brand.send(sym, *args)")
    else
      nil
    end
  end

  def featured_products
    Rails.cache.fetch("#{cache_key_with_version}/featured_products", expires_in: 6.hours) do
      begin
        @featured_products ||= self.brand.respond_to?(:featured_products) ?
          self.brand.featured_products.split(/\,|\|\s?/).map{|i| Product.find_by(cached_slug: i)}.select{|p| p if p.show_on_website?(self)} :
          Array.new
      rescue
        Array.new
      end
    end
  end

  def product_families
    Rails.cache.fetch("#{cache_key_with_version}/product_families", expires_in: 6.hours) do
      ProductFamily.all_with_current_or_discontinued_products(self, I18n.locale)
    end
  end

  def current_and_discontinued_products(included_attributes=[])
    included_attributes << :product_status
    Rails.cache.fetch("#{cache_key_with_version}/#{included_attributes.join}/current_and_discontinued_products", expires_in: 2.hours) do
      brand.products.includes(included_attributes).where(product_status_id: ProductStatus.current_and_discontinued_ids)
    end
  end

  def current_and_discontinued_product_ids
    Rails.cache.fetch("#{cache_key_with_version}/current_and_discontinued_product_ids", expires_in: 2.hours) do
      brand.products.where(product_status_id: ProductStatus.current_and_discontinued_ids).pluck(:id)
    end
  end

  def discontinued_and_vintage_products
    Rails.cache.fetch("#{cache_key_with_version}/discontinued_and_vintage_products", expires_in: 6.hours) do
      brand.products.includes(:product_status).select{|p| p if !!(p.product_status.name.match(/discontinue|vintage/i))}
    end
  end

  def vintage_products
    Rails.cache.fetch("#{ cache_key_with_version}/vintage_products", expires_in: 1.week) do
      brand.products.includes(:product_status).select{|p| p if !!(p.product_status.name.match(/vintage/i))}
    end
  end

  def all_downloads(user)
    SiteElement.downloads(self, user).deep_merge ProductDocument.downloads(self)
  end

  # Most likely not used anymore. This was useful when all the site elements and documents
  # were stored locally on the server. Then we could offer a zip-and-download-all function
  # which isn't really feasible now with external storage and the giant quantity of files.
  def zip_downloads(download_type, user)
    downloads = self.all_downloads(user)[download_type][:downloads]

    t = Tempfile.new("#{self.brand.name.parameterize}-temp-filename-#{Time.now}")
    Zip::OutputStream.open(t.path) do |z|
      downloads.each do |dl|
        z.put_next_entry(dl[:file_name])
        z.print IO.read(dl[:path])
      end
    end
    t
  end

  def artists
    Artist.all_for_website(self)
  end

  def add_log(attributes)
    attributes[:website_id] = self.id
    if attributes[:user]
      attributes[:user_id] = attributes[:user].id
      attributes.delete(:user)
    end
    begin
      AdminLog.create(attributes)
    rescue
      # don't worry if we can't log stuff
    end
  end

  def training_modules(options={})
    TrainingModule.modules_for(self.brand, options)
  end

  # Common default domain for google analytics
  def domain
    url.to_s.match(/www/i) ? url.to_s.match(/(\w{1,}\.+\w{2,3}(\.\w{2,3})?)$/).to_s : url.to_s
  end

  # cache the twitter name so it is only pulled once per call
  def twitter_name
    @twitter_name ||= self.brand.twitter_name
  end

  def has_news?
    self.brand.has_news?
  end

end
