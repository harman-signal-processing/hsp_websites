class ApplicationController < ActionController::Base
  # before_action :set_locale
  before_action :respond_to_htm
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ensure_locale_for_site, except: [:locale_root, :default_locale, :locale_selector]
  before_action :catch_criminals
  before_action :hold_on_to_utm_params
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  layout :set_layout

  # This method is getting complicated...It chooses the appropriate layout file based on
  # several criteria: whether or not this is a devise (user login) controller, whether or
  # not the website's brand has a custom layout (usually should), etc., whether or not
  # the 'website' object exists...
  #
  def set_layout
    template = 'application'

    controller_brand_specific = "#{website.folder}/layouts/#{controller_path}"
    controller_specific = "layouts/#{controller_path}"
    brand_specific = "#{website.folder}/layouts/application"
    homepage = "#{website.folder}/layouts/home"

    if devise_controller? && resource_name == :artist
      artist_brand_specific = "#{website.folder}/layouts/artists"
      if File.exists?(Rails.root.join("app", "views", "#{artist_brand_specific}.html.erb"))
        template = artist_brand_specific
      elsif File.exists?(Rails.root.join("app", "views", "layouts", "artists.html.erb"))
        template = "artists"
      elsif File.exists?(Rails.root.join("app", "views", "#{brand_specific}.html.erb"))
        template = brand_specific
      end
    #elsif devise_controller? && resource_name == :user
    #  template = "admin"
    elsif controller_path == 'main' && action_name == 'index' && File.exists?(Rails.root.join("app", "views", "#{homepage}.html.erb"))
      template = homepage
    elsif File.exists?(Rails.root.join("app", "views", "#{controller_brand_specific}.html.erb"))
      template = controller_brand_specific
    elsif File.exists?(Rails.root.join("app", "views", "#{controller_specific}.html.erb"))
      template = controller_specific
    elsif File.exists?(Rails.root.join("app", "views", "#{brand_specific}.html.erb"))
      template = brand_specific
    end

    template
  end

  # Used as a replacement for rails' built-in renderer. This one checks the filesystem
  # to see if any brand or locale specific views have been provided. If so, it renders
  # that. If not, it renders the usual rails view.
  #
  def render_template(options={})
    default_options = {
      controller: controller_path,
      action: action_name,
      layout: set_layout,
      locale: I18n.locale
    }
    options = default_options.merge options
    root_folder = (website && website.folder) ? "#{website.folder}/" : ''

    brand_and_locale_specific = "#{root_folder}#{options[:controller]}/#{options[:locale]}/#{options[:action]}"
    brand_specific = "#{root_folder}#{options[:controller]}/#{options[:action]}"
    locale_specific = "#{options[:controller]}/#{options[:locale]}/#{options[:action]}"
    template = "#{options[:controller]}/#{options[:action]}" # the default
    response_format = request.format.symbol.to_s
    if File.exists?(Rails.root.join("app", "views", "#{brand_and_locale_specific}.#{response_format}.erb"))
      template = brand_and_locale_specific
    elsif File.exists?(Rails.root.join("app", "views", "#{brand_specific}.#{response_format}.erb"))
      template = brand_specific
    elsif File.exists?(Rails.root.join("app", "views", "#{locale_specific}.#{response_format}.erb"))
      template = locale_specific
    end

    render template: template, layout: options[:layout]
  end # def render_template

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_root_path, alert: exception.message
  end

  def default_url_options(options={})
    { locale: I18n.locale }
  end

  # Utility function used to re-order an ActiveRecord list
  # Pass in a model name and a list of ordered objects
  def update_list_order(model, order)
    order.to_a.each_with_index do |item, pos|
      model.update(item, position:(pos + 1))
    end
  end

private

  # Used as a filter, redirects to the site's default locale if the site is not
  # configured for the locale passed by the user. I have a feeling this is going
  # to cause problems.
  #
  def ensure_locale_for_site
    if (website && website.folder) # (skips this filter for tooklit)

      raise ActionController::RoutingError("Site not found.") unless website.respond_to?(:list_of_available_locales)

      if params[:locale] && !params[:locale].to_s.match(/en/i) && l = website.list_of_available_locales
        unless l.include?(params[:locale].to_s)
          new_locale = website.default_locale || I18n.default_locale.to_s
          redirect_to locale_root_path(new_locale), status: :moved_permanently and return false
        end
      end

    end
  end

  # Old sites often come through with *.htm extensions instead of *.html. Fix it.
  def respond_to_htm
    if params[:format] && params[:format] == 'htm'
      request.format = 'html'
    end
  end

  def catch_criminals
    begin
      x = request.env["HTTP_X_FORWARDED_FOR"].to_s
      i = request.remote_ip.to_s
      if x.match(/198\.91\.53/) || i.match(/198\.91\.53/) || x.match(/162\.211\.152/) || i.match(/162\.211\.152/)
        # send this idiot back to his own ISP
        redirect_to "http://www.securitymetrics.com#{ENV['REQUEST_URI']}" and return false
      end
      if params && params[:page]
        page = params[:page]
        unless page.to_s.match(/^[0-9]{1,5}$/i) # anything not a number is a bad page number
          render plain: "Pretty sneaky", status: 400 and return false
        end
      end
    rescue
    end
  end

  def website
    @website ||= Website.where(url: request.host).first
  end
  helper_method :website

  # TODO: the big if statement below setting the locale needs to be refactored and will eventually include plenty of other countries
  def set_locale
    # This isn't really setting the locale, we're just trying
    # to be smart and pick the user's country for "Buy It Now"
    begin
      if params['geo']
        session['geo_country'] = clean_country_code
        session['geo_usa'] = (clean_country_code == "us") ? true : false
      else
        unless session['geo_country']
          lookup = Geokit::Geocoders::GeoPluginGeocoder.do_geocode(request.remote_ip)
          if lookup.success? || lookup.country_code
            session['geo_country'] = lookup.country_code
            session['geo_usa'] = lookup.is_us?
            session['geo_usa_state'] = lookup.state
          else
            session['geo_country'] = "US"
            session['geo_usa'] = true
            session['geo_usa_state'] = nil
          end
        end
      end
    rescue
      #session['geo_country'] = "US"
      #session['geo_usa'] = true
    end

    raise ActionController::RoutingError.new("Site not found") unless website && website.respond_to?(:list_of_available_locales)

    # This is where we set the locale:
    if params.key?(:locale)
      I18n.locale = params[:locale]
    elsif !!(session['geo_usa']) && website.list_of_available_locales.include?("en-US")
      I18n.locale = 'en-US'
    elsif session['geo_country'] == "CN" && website.list_of_available_locales.include?("zh")
      I18n.locale = 'zh'
    elsif session['geo_country'] == "UK" && website.list_of_available_locales.include?("en")
      I18n.locale = 'en'
    elsif website.locale
      I18n.locale = website.locale
    elsif website.show_locales? && controller_path == "main" && action_name == "default_locale"
      locale_selector # otherwise the default locale is appended to the URL. #ugly
    else
      redirect_to root_path, status: :moved_permanently and return false
    end

    if params[:locale] && params[:locale].to_s != I18n.locale.to_s
      redirect_to url_for(request.params.merge(locale: I18n.locale)) and return false
    end

    # Handling inactive locales for the current site
    if !website.list_of_available_locales.include?(I18n.locale.to_s)
      unless can?(:manage, Product) # Admins can view non-active locales
        redirect_to url_for(request.params.merge(locale: website.list_of_available_locales.first)) and return false
      end
    end
  end

  # locale selector
  def locale_selector
    render_template(action: "locale_selector", layout: "locale")
  end

  def current_ability
    if current_user
      @current_ability ||= Ability.new(current_user)
    elsif current_artist
      @current_ability ||= Ability.new(current_artist)
    else
      @current_ability ||= Ability.new(User.new)
    end
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(Artist)
      artist_root_path
    else
      session["#{ resource.class.name.downcase }_return_to".to_sym] ||
        stored_location_for(resource) || profile_path || super
    end
  end

  def after_inactive_sign_up_path_for(resource)
    if resource.is_a?(Artist)
      new_artist_session_path
    else
      super
    end
  end

  def restrict_api_access
    if Rails.env.production?
      authenticate_or_request_with_http_token do |token, options|
        ApiKey.exists?(access_token: token)
      end
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :name,
      :email,
      :password,
      :password_confirmation,
      :invitation_code,
      :signup_type,
      :dealer,
      :distributor,
      :rep,
      :employee,
      :media,
      :artist,
      :clinician,
      :rso,
      :website,
      :artist_photo,
      :artist_product_photo,
      :bio,
      :main_instrument,
      :twitter,
      :artist_products,
      :job_title,
      :job_description,
      :phone_number,
      :account_number,
      :profile_pic])
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :name,
      :email,
      :password,
      :password_confirmation,
      :current_password,
      :website,
      :artist_photo,
      :artist_product_photo,
      :bio,
      :main_instrument,
      :twitter,
      :artist_products,
      :job_title,
      :job_description,
      :phone_number,
      :account_number,
      :profile_pic])
  end

  def us_states
    states = {
    "AL": "Alabama",
    "AK": "Alaska",
    # "AS": "American Samoa",
    "AZ": "Arizona",
    "AR": "Arkansas",
    "CA": "California",
    "CO": "Colorado",
    "CT": "Connecticut",
    "DE": "Delaware",
    "DC": "District Of Columbia",
    # "FM": "Federated States Of Micronesia",
    "FL": "Florida",
    "GA": "Georgia",
    # "GU": "Guam",
    "HI": "Hawaii",
    "ID": "Idaho",
    "IL": "Illinois",
    "IN": "Indiana",
    "IA": "Iowa",
    "KS": "Kansas",
    "KY": "Kentucky",
    "LA": "Louisiana",
    "ME": "Maine",
    # "MH": "Marshall Islands",
    "MD": "Maryland",
    "MA": "Massachusetts",
    "MI": "Michigan",
    "MN": "Minnesota",
    "MS": "Mississippi",
    "MO": "Missouri",
    "MT": "Montana",
    "NE": "Nebraska",
    "NV": "Nevada",
    "NH": "New Hampshire",
    "NJ": "New Jersey",
    "NM": "New Mexico",
    "NY": "New York",
    "NC": "North Carolina",
    "ND": "North Dakota",
    # "MP": "Northern Mariana Islands",
    "OH": "Ohio",
    "OK": "Oklahoma",
    "OR": "Oregon",
    # "PW": "Palau",
    "PA": "Pennsylvania",
    # "PR": "Puerto Rico",
    "RI": "Rhode Island",
    "SC": "South Carolina",
    "SD": "South Dakota",
    "TN": "Tennessee",
    "TX": "Texas",
    "UT": "Utah",
    "VT": "Vermont",
    # "VI": "Virgin Islands",
    "VA": "Virginia",
    "WA": "Washington",
    "WV": "West Virginia",
    "WI": "Wisconsin",
    "WY": "Wyoming"
    }  #  states = {
    states
  end  #  us_states
  helper_method :us_states

  def clean_country_code
    (params[:geo].blank?) ? (session['geo_country'].blank? ? "us" : get_clean_first_two_characters_downcased(session['geo_country'])) : get_clean_first_two_characters_downcased(params[:geo])
  end
  helper_method :clean_country_code

  def get_clean_first_two_characters_downcased(text)
    clean = text.gsub(/[^a-zA-Z]/, '').slice(0..1).downcase
    clean.blank? ? "us" : clean
  end

  def in_apac?
    ISO3166::Country.find_all_countries_by_world_region('APAC').collect(&:alpha2).include? clean_country_code.upcase
  end
  helper_method :in_apac?

  def in_caribbean?
    ISO3166::Country.find_all_countries_by_subregion('Caribbean').collect(&:alpha2).include? clean_country_code.upcase
  end
  helper_method :in_caribbean?

  def in_central_america?
    ISO3166::Country.find_all_countries_by_subregion('Central America').collect(&:alpha2).include? clean_country_code.upcase
  end
  helper_method :in_central_america?

  def in_emea?
    ISO3166::Country.find_all_countries_by_world_region('EMEA').collect(&:alpha2).include? clean_country_code.upcase
  end
  helper_method :in_emea?

  def in_south_america?
    ISO3166::Country.find_all_countries_by_subregion('South America').collect(&:alpha2).include? clean_country_code.upcase
  end
  helper_method :in_south_america?

  def hold_on_to_utm_params
    utm_campaign = params[:utm_campaign]
    utm_medium = params[:utm_medium]
    utm_source = params[:utm_source]
    utm_content = params[:utm_content]

    cookies[:utm_campaign] = {  value: utm_campaign } if !utm_campaign.nil?
    cookies[:utm_medium] = {  value: utm_medium } if !utm_medium.nil?
    cookies[:utm_source] = {  value: utm_source } if !utm_source.nil?
    cookies[:utm_content] = {  value: utm_content } if !utm_content.nil?
  end  #  def hold_on_to_utm_params

  def sanitize_param_value(unsanitized_param_value, allowed_punctuation=[])
    # strip non printable characters and unallowed punctuation characters from unsanitized_param_value
    sanitized_item = unsanitized_param_value.gsub(/[^[:print:]]/, '').gsub(/[[:punct:]]/) { |item| (allowed_punctuation.include? item) ? item : "" } if unsanitized_param_value.present?
    sanitized_item
  end

  def authorize_query!(query)
    if query.to_s.match(/union\s{1,}select/i) ||
       query.to_s.match(/(and|\&*)\s{1,}sleep/i) ||
       query.to_s.match(/order\s{1,}by/i) ||
       query.to_s.match(/query-1|1\=1/)
      raise ActionController::UnpermittedParameters.new ["query not allowed"]
    end
  end

  rescue_from ActionController::UnpermittedParameters do |error|
    render plain: error, status: 401
  end

end

class ::Hash
  def deep_merge(second)
    merger = proc { |_, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : Array === v1 && Array === v2 ? v1 | v2 : [:undefined, nil, :nil].include?(v2) ? v1 : v2 }
    merge(second.to_h, &merger)
  end
end
