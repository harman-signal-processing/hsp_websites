class ApplicationController < ActionController::Base
  # before_filter :set_locale
  before_filter :set_default_meta_tags
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  layout :set_layout

  unless config.consider_all_requests_local || Rails.env.development?
    # rescue_from Exception, :with => :render_error
    rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
    rescue_from ActionController::RoutingError, :with => :render_not_found
    rescue_from ActionController::UnknownController, :with => :render_not_found
    # customize these as much as you want, ie, different for every error or all the same
    rescue_from ::AbstractController::ActionNotFound, :with => :render_not_found
  end

  # This method is getting complicated...It chooses the appropriate layout file based on
  # several criteria: whether or not this is a devise (user login) controller, whether or
  # not the website's brand has a custom layout (usually should), etc.
  #
  def set_layout
    template = 'application'
    if (website && website.folder) 
      controller_brand_specific = "#{website.folder}/layouts/#{controller_path}"
      brand_specific = "#{website.folder}/layouts/application"
      if devise_controller? && resource_name == :artist
        artist_brand_specific = "#{website.folder}/layouts/artists"
        if File.exists?(Rails.root.join("app", "views", "#{artist_brand_specific}.html.erb"))
          template = artist_brand_specific
        elsif File.exists?(Rails.root.join("app", "views", "layouts", "artists.html.erb"))
          template = "artists"
        elsif File.exists?(Rails.root.join("app", "views", "#{brand_specific}.html.erb"))
          template = brand_specific
        end
      elsif devise_controller? && resource_name == :user
        template = "admin"
      elsif File.exists?(Rails.root.join("app", "views", "#{controller_brand_specific}.html.erb"))
        template = controller_brand_specific
      elsif File.exists?(Rails.root.join("app", "views", "#{brand_specific}.html.erb"))
        template = brand_specific
      end
    end
    template
  end
  
  def render_template(options={})
    default_options = {:controller => controller_path, :action => action_name, :layout => set_layout}
    options = default_options.merge options
    root_folder = (website && website.folder) ? "#{website.folder}/" : ''
    brand_specific = "#{root_folder}#{options[:controller]}/#{options[:action]}"
    generic = "#{options[:controller]}/#{options[:action]}"
    template = (File.exists?(Rails.root.join("app", "views", "#{brand_specific}.html.erb"))) ? brand_specific : generic
    logger.debug "------> Brand template: #{brand_specific}"
    logger.debug "----------------------------> Selected Template: #{template}"
    render :template => template, :layout => options[:layout]
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_root_path, :alert => exception.message
  end
  
  def set_default_meta_tags
    begin
      @page_description = website.value_for('default_meta_tag_description')
      @page_keywords = website.value_for("default_meta_tag_keywords")
    rescue
      @page_description = ""
      @page_keywords = ""
    end
  end
  
  def default_url_options(options={})
    # {:locale => website.locale}
    {:locale => I18n.locale}
  end
  
  # Utility function used to re-order an ActiveRecord list
  # Pass in a model name and a list of ordered objects
  def update_list_order(model, order)
    order.to_a.each_with_index do |item, pos|
      model.update(item, :position =>(pos + 1))
    end
  end

private

  def render_not_found(exception)
    error_page(404)
  end
  
  def render_error(exception)
    error_page(500)
  end
  
  def error_page(status=404)
    root_folder = (website && website.folder) ? "#{website.folder}/" : ''
    generic = "errors/#{status}"
    brand_specific = "#{root_folder}#{generic}"
    template = (File.exists?(Rails.root.join("app", "views", "#{brand_specific}.html.erb"))) ? brand_specific : generic
    render :template => template, :layout => false, :status => status and return
  end
  
  def website
    if Rails.env.production? || Rails.env.staging?
      @website ||= Website.find_by_url(request.host)
    else
      default_brand = (BRAND_ID) ? Brand.find(BRAND_ID) : Brand.first
      default_folder = default_brand.name.downcase.gsub(/\s/, "_")
      @website ||= Website.find_by_url(request.host) || Website.new(:brand => default_brand, :url => "localhost", :folder => default_folder)
    end
  end
  helper_method :website
  
  def require_admin_authentication
    authenticate_or_request_with_http_basic do |user_name, password|
      password == ADMIN_PASSWORD
    end
  end

  def set_locale
    # This isn't really setting the locale, we're just trying
    # to be smart and pick the user's country for "Buy It Now"
    begin
      if params['geo']
        session['geo_country'] = params['geo']
        session['geo_usa'] = (params['geo'] == "US") ? true : false
      else
        unless session['geo_country']
          ip = request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip
          lookup = GeoKit::Geocoders::GeoPluginGeocoder.do_geocode(ip)
          # lookup = GeoKit::Geocoders::MultiGeocoder.do_geocode(ip)
          if lookup.success? || lookup.country_code
            session['geo_country'] = lookup.country_code
            session['geo_usa'] = lookup.is_us?
          else
            session['geo_country'] = "US"
            session['geo_usa'] = true
          end
          # c = GeoIP.new(Rails.root.join("db", "GeoIPCountryWhois.csv")).country(ip)
          # session['geo_country'] = c.country_code3
          # session['geo_usa'] = (session['geo_country'].match(/^US/)) ? true : false
        end
      end
    rescue
      session['geo_country'] = "US"
      session['geo_usa'] = true
    end
    # This is where we set the locale:
    if params[:locale]
      I18n.locale = params[:locale]
    else
      # I18n.locale = "en-US"
      redirect_to root_path and return false
    end
  end

end
