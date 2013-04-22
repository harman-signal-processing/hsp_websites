class Website < ActiveRecord::Base
  belongs_to :brand, touch: true
  has_many :website_locales
  validates_presence_of :url, :brand_id, :folder
  validates_uniqueness_of :url
  
  def value_for(key, locale=I18n.locale)
    brand.value_for(key, locale)
  end
  
  def features
    begin
      f = brand.settings.where(setting_type: "homepage feature").where("slide_file_name IS NOT NULL").order(:integer_value)
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

  def auto_translate_locales
    list_of_all_locales.reject{|i| i.match(/en/)}
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
  
  def method_missing(sym, *args)
    if self.brand.respond_to?(sym)
      variable_name = sym.to_s.gsub(/\W/, "")
      eval("@#{variable_name} ||= self.brand.send(sym, *args)")
    else
      nil
    end
  end
  
  def current_and_discontinued_products(included_attributes=[])
    included_attributes << :product_status
    @current_and_discontinued_products ||= self.brand.products.includes(included_attributes).select{|p| p if p.show_on_website?(self)}
  end

  def vintage_products
    @vintage_products ||= self.brand.products.includes(:product_status).select{|p| p if !!(p.product_status.name.match(/vintage/i))}
  end
  
  def all_downloads
    downloads = {}
    self.current_and_discontinued_products([:product_documents, :product_attachments]).each do |product|
      product.product_documents.each do |product_document|
        doctype = (product_document.document_type.blank?) ? "Misc" : I18n.t("document_type.#{product_document.document_type}")
        if !product_document.language.blank?
          doctype = "#{I18n.t("language.#{product_document.language}")} #{doctype}" unless doctype.to_s.match(/CAD/)
        end
        downloads[doctype.parameterize] ||= {param_name: doctype.parameterize, name: doctype.pluralize, downloads: []}
        link_name = !!(doctype.match(/other/i)) ? product_document.document_file_name : product.name
        downloads[doctype.parameterize][:downloads] << {
          name: link_name, 
          file_name: product_document.document_file_name,
          url: product_document.document.url, 
          path: product_document.document.path
        }
      end
      # images need better name (non-redundant)
      product.product_attachments.each do |product_attachment|
        if product_attachment.is_photo?
          doctype = "Photo"
          downloads[doctype.parameterize] ||= {param_name: doctype.parameterize, name: doctype.pluralize, downloads: []}
          begin
            thumbnail = product_attachment.product_attachment.url(:tiny_square)
          rescue
            thumbnail = nil
          end
          downloads[doctype.parameterize][:downloads] << {
            name: product_attachment.product_attachment_file_name, 
            file_name: product_attachment.product_attachment_file_name,
            thumbnail: thumbnail,
            url: product_attachment.product_attachment.url,
            path: product_attachment.product_attachment.path
          }
        end
      end
      # product.softwares.each do |software|
      #   doctype = "Software"
      #   downloads[doctype.parameterize] ||= {param_name: doctype.parameterize, name: doctype, downloads: []}
      #   downloads[doctype.parameterize][:downloads] << {name: software.formatted_name, url: download_software_url(software)}
      # end
      # if downloads["Software".parameterize]
      #   downloads["Software".parameterize][:downloads].uniq!
      # end
    end
    self.site_elements.where(show_on_public_site: true).each do |site_element|
      downloads[site_element.resource_type.parameterize] ||= {param_name: site_element.resource_type.parameterize, name: site_element.resource_type.to_s.pluralize, downloads: []}
      thumbnail = nil
      if !site_element.resource_file_name.blank? #&& site_element.is_image?
        if site_element.is_image?
          thumbnail = site_element.resource.url(:tiny_square)
        end
        downloads[site_element.resource_type.parameterize][:downloads] << {
          name: site_element.name,
          file_name: site_element.resource_file_name,
          thumbnail: thumbnail,
          url: site_element.resource.url,
          path: site_element.resource.path
        }
      else
        downloads[site_element.resource_type.parameterize][:downloads] << {
          name: site_element.name,
          file_name: site_element.executable_file_name,
          thumbnail: nil,
          url: site_element.executable.url,
          path: site_element.executable.path
        }
      end
    end
    # logger.debug " =============================================== \n #{downloads.to_yaml}"
    downloads
  end
  
  def zip_downloads(download_type)
    downloads = self.all_downloads[download_type][:downloads]

    t = Tempfile.new("#{self.brand.name.parameterize}-temp-filename-#{Time.now}")
    Zip::ZipOutputStream.open(t.path) do |z|
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
  
end
