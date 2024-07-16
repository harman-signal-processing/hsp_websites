class ApplicationController < ActionController::Base
  before_action :set_geo, :catch_criminals
  # before_action :set_locale
  before_action :respond_to_htm
  before_action :configure_permitted_parameters, if: :devise_controller?
  # 2022-10 [AA] see below
  # before_action :ensure_locale_for_site, except: [:locale_root, :default_locale, :locale_selector]
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
      if File.exist?(Rails.root.join("app", "views", "#{artist_brand_specific}.html.erb"))
        template = artist_brand_specific
      elsif File.exist?(Rails.root.join("app", "views", "layouts", "artists.html.erb"))
        template = "artists"
      elsif File.exist?(Rails.root.join("app", "views", "#{brand_specific}.html.erb"))
        template = brand_specific
      end
    #elsif devise_controller? && resource_name == :user
    #  template = "admin"
    elsif controller_path == 'main' && action_name == 'index' && File.exist?(Rails.root.join("app", "views", "#{homepage}.html.erb"))
      template = homepage
    elsif File.exist?(Rails.root.join("app", "views", "#{controller_brand_specific}.html.erb"))
      template = controller_brand_specific
    elsif File.exist?(Rails.root.join("app", "views", "#{controller_specific}.html.erb"))
      template = controller_specific
    elsif File.exist?(Rails.root.join("app", "views", "#{brand_specific}.html.erb"))
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
    if File.exist?(Rails.root.join("app", "views", "#{brand_and_locale_specific}.#{response_format}.erb"))
      template = brand_and_locale_specific
    elsif File.exist?(Rails.root.join("app", "views", "#{brand_specific}.#{response_format}.erb"))
      template = brand_specific
    elsif File.exist?(Rails.root.join("app", "views", "#{locale_specific}.#{response_format}.erb"))
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
  # 2022-10 [AA] No longer used since RV is launching translated pages for individual
  #   products without doing a full translation. This is probably going to raise
  #   concerns like, "Hey, how come when I go to /fr/some-product, it isn't in French?
  #   Well, remember how you wanted to launch individual products that were translated.
  #   That's why.
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
    if request.format == 'htm'
      request.format = 'html'
    end
  end

  def catch_criminals
    # 2022-08 Getting lots of geniuses trying to POST JSON. Let's just give them an error without much info:
    # This globally blocks POSTing JSON. Bypass this filter in your controller if POSTing JSON is required.
    handle_posting_json

    handle_posting_empty_body

    handle_posting_empty_content_type

    if website.present?
      post_param_not_allowed_value = website.value_for('post_param_not_allowed')
      handle_bad_posts(post_param_not_allowed_value)

      path_not_allowed_value = website.value_for('path_not_allowed')
      handle_bad_path(path_not_allowed_value)
    end

    # Alright, we're just going to look at all params for SQLi. This is probably going
    # to slow us down a bit. Thanks a lot hacker fools.
    if params.present?
      handle_sql_injection_requests
    end

  end  #  def catch_criminals

  def handle_posting_json
    if request.content_type.to_s.match?(/json/i) && request.post?
      BadActorLog.create(ip_address: request.remote_ip, reason: "POSTing JSON", details: "#{request.inspect}\n\n#{request.env["RAW_POST_DATA"]}")
      log_bad_actors(request.remote_ip, "POSTing JSON")
      raise ActionController::UnpermittedParameters.new ["not allowed"]
    end
  end
  def handle_posting_empty_body
    if request.raw_post.present?
      if request.post? && request.raw_post.gsub("-","").empty?
        BadActorLog.create(ip_address: request.remote_ip, reason: "Empty POST", details: "#{request.inspect}\n\n#{request.raw_post}")
        log_bad_actors(request.remote_ip, "Empty POST")
        head :bad_request
      end
    end
  end
  def handle_posting_empty_content_type
    content_type = request.content_type.nil? ? "" : request.content_type.gsub("-","")
    if request.post? && content_type.empty?
      raw_post_data = request.raw_post.truncate(250)
      BadActorLog.create(ip_address: request.remote_ip, reason: "Empty Content Type", details: "#{request.inspect}\n\n#{raw_post_data}")
      log_bad_actors(request.remote_ip, "Empty Content Type")
      head :bad_request
    end
  end
  def handle_bad_posts(post_param_not_allowed_value)
    if post_param_not_allowed_value.present? && request.raw_post.present?
      bad_post_word_array = post_param_not_allowed_value.downcase.gsub(/\s/,"").split(",")
      bad_post_param_pattern = /\b(?:#{bad_post_word_array.join('|')})\b/i
      bad_post_found = request.raw_post.match?(bad_post_param_pattern)
      if bad_post_found
        raw_post_data = request.raw_post.truncate(250)
        BadActorLog.create(ip_address: request.remote_ip, reason: "Bad Post", details: "#{request.inspect}\n\n#{raw_post_data}")
        log_bad_actors(request.remote_ip, "Bad Post")
        head :bad_request
      end
    end
  end
  def handle_bad_path(path_not_allowed_value)
    if path_not_allowed_value.present?
      bad_path_word_array = path_not_allowed_value.downcase.gsub(/\s/,"").split(",")
      bad_path_pattern = /(?:#{bad_path_word_array.map { |word| Regexp.escape(word) }.join('|')})/i
      bad_path_found = request.fullpath.match?(bad_path_pattern)
      if bad_path_found
        raw_post_data = request.raw_post.truncate(250)
        BadActorLog.create(ip_address: request.remote_ip, reason: "Bad Path", details: "#{request.inspect}\n\n#{raw_post_data}")
        log_bad_actors(request.remote_ip, "Bad Path")
        head :bad_request
      end
    end
  end
  def handle_sql_injection_requests
      # checking all params as a string to avoid extra looping
      if has_sqli?(params.to_unsafe_h.flatten.to_s)
        BadActorLog.create(ip_address: request.remote_ip, reason: "SQLi attempt", details: "#{request.inspect}\n\n#{params.inspect}")
        log_bad_actors(request.remote_ip, "SQLi attempt")
        raise ActionController::UnpermittedParameters.new(["pESop jup"])
      end
  end

  def log_bad_actors(ip_address, reason)
    logger = ActiveSupport::Logger.new("log/brandsite_bad_actor.log")
    time = Time.now
    formatted_datetime = time.strftime('%Y-%m-%d %I:%M:%S %p')
    logger.error "#{ ip_address } - - [#{formatted_datetime}] \"#{ reason }\" ~~ #{request.inspect}"
  end

  # use this as a before_action filter in controllers where big bad hackers are trying to request
  # image formats from our controllers.
  def reject_image_requests
    if request.format.to_s.match?(/jpg|jpeg|png|gif|svg|ttf/i)
      raise ActionController::UnpermittedParameters.new ["invalid format"]
    end
  end

  def website
    @website ||= Website.where(url: request.host).first
  end
  helper_method :website

  # TODO: the big if statement below setting the locale needs to be refactored and will eventually include plenty of other countries
  def set_locale
    raise ActionController::RoutingError.new("Site not found") unless website && website.respond_to?(:list_of_available_locales)

    current_country = ISO3166::Country.new( clean_country_code.upcase )
    if current_country && current_country.languages_official.present?
      cross_section_languages = current_country.languages_official & website.list_of_available_locales
    else
      cross_section_languages = []
    end

    # This is where we set the locale:

    # If params[:locale] is provided, do some smart redirecting for the English variations
    if params.key?(:locale)
      I18n.locale = params[:locale]
      unless is_search_engine? || can?(:manage, Product) # lets admins and crawlers around geofencing
        case params[:locale]
          when "en-US"
            # 2023-08-22 AA disabled en-asia automatic redirect due to Portable Live Sound families being incomplete in en-asia
            if !session[:geo_usa] && website.list_of_available_locales.include?("en")
              I18n.locale = "en"
            #elsif in_apac? && website.list_of_available_locales.include?("en-asia")
            #  I18n.locale = "en-asia"
            end
          when "en-asia"
            if !!session[:geo_usa] && website.list_of_available_locales.include?("en-US")
              I18n.locale = "en-US"
            elsif !in_apac? && website.list_of_available_locales.include?("en")
              I18n.locale = "en"
            end
          when "en"
            # 2023-08-22 AA disabled en-asia automatic redirect due to Portable Live Sound families being incomplete in en-asia
            if !!session[:geo_usa] && website.list_of_available_locales.include?("en-US")
              I18n.locale = "en-US"
            #elsif in_apac? && website.list_of_available_locales.include?("en-asia")
            #  I18n.locale = "en-asia"
            end
        end
      end

    # Session is missing geo data for some reason, send to default
    elsif !session['geo_country']
      #logger.geo.debug("Session data was missing, sending user to en")
      I18n.locale = 'en'

    # When no params[:locale] is provided, go through these rules to pick one:
    elsif !!(session['geo_usa']) && website.list_of_available_locales.include?("en-US")
      I18n.locale = 'en-US'

    # When in apac
    elsif in_apac?
      if current_country.languages_official.include?("zh") && website.list_of_all_locales.include?("zh")
        I18n.locale = "zh"
      elsif website.list_of_available_locales.include?("en-asia")
        I18n.locale = "en-asia"
      end

    #TODO: handle language-country locales like pt-BR

    # If the visitor's country's official languages matches one of our available locales, choose the first one
    elsif cross_section_languages.size > 0
      I18n.locale = cross_section_languages.first

    # If the visitor's country code matches one of our available locales, choose that.
    elsif website.list_of_all_locales.include?( clean_country_code )
      I18n.locale = clean_country_code

    elsif website.locale
      I18n.locale = website.locale

    # I don't think we ever get to the locale selector anymore
    elsif website.show_locales? && controller_path == "main" && action_name == "default_locale"
      locale_selector # otherwise the default locale is appended to the URL. #ugly

    else
      redirect_to root_path, status: :moved_permanently and return false
    end

    if params[:locale] && params[:locale].to_s != I18n.locale.to_s && request.get?
      #logger.geo.debug("params[:locale] was #{params[:locale]}, Redirecting to #{ request.params.merge(locale: I18n.locale)} ")
      redirect_to url_for(request.params.merge(locale: I18n.locale)) and return false
    end

    # Handling inactive locales for the current site
    if !website.list_of_all_locales.include?(I18n.locale.to_s)
      unless can?(:manage, Product) # Admins can view non-active locales
        #logger.geo.debug(" #{ I18n.locale.to_s } is not a locale for #{ website.brand.name }, redirecting to #{ I18n.default_locale.to_s }")
        redirect_to url_for(request.params.merge(locale: I18n.default_locale.to_s)) and return false
      end
    end
  end

  def set_geo
    begin
      if params['geo']
        session['geo_country'] = clean_country_code
        session['geo_usa'] = (clean_country_code == "us") ? true : false
      else
        unless session['geo_country']
          # MultiGeocoder should automatically use IP services in the order of
          # preference indicated in config/initializers/geokit_config.rb
          lookup = Geokit::Geocoders::MultiGeocoder.do_geocode(request.remote_ip)
          if lookup.present? && lookup.country_code.present?
            session['geo_country'] = lookup.country_code
            session['geo_usa'] = lookup.is_us?
            session['geo_usa_state'] = lookup.state
          else
            session['geo_country'] = "UK"
            session['geo_usa'] = false
            session['geo_usa_state'] = nil
          end
        end
      end
    rescue
      session['geo_country'] = "UK"
      session['geo_usa'] = false
      session['geo_usa_state'] = nil
      #logger.geo.debug(" Problem with 'set_geo' method for: #{ request.remote_ip }, Session: #{ session.inspect } ")
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

  # NZ wants to see /en site instead of /en-asia
  def in_apac?
    (ISO3166::Country.find_all_countries_by_world_region('APAC').collect(&:alpha2) - ["NZ"]).include? clean_country_code.upcase
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

  def has_sqli?(input)
      sqli_pattern = /\b(?:SELECT|INSERT INTO|UPDATE|DELETE FROM|UNION)\b.*?\b(?:CONCAT|FROM|INTO|SELECT|SLEEP|WHERE|VALUES)\b/i
    if input.respond_to?(:any?)
      input.any?(sqli_pattern)
    else
      input.to_s.match?(sqli_pattern)
    end
  end

  # Check the user-agent for common search engine crawlers
  def is_search_engine?
    !!request.headers['User-Agent'].to_s.match?(/aolbuild|baidu|bingbot|bingpreview|msnbot|duckduckgo|adsbot-google|googlebot|mediapartners-google|teoma|slurp|yandex/i)
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

# Monkey-patching titleize function because we use it a lot, but
# it tends to screw up titles in other languages. Here we can do
# different titleizeing based on the locale.
#
# The default approach for all non-English languages is to do
# nothing, but we may want to use "upcase_first()" instead.
#
module ActiveSupport
	module Inflector

		def titleize(word, keep_id_suffix: false)
			case I18n.locale.to_s
        when /^en/i
          humanize(underscore(word), keep_id_suffix: keep_id_suffix).gsub(/\b(?<!\w['’`()])[a-z]/) do |match|
            match.capitalize
          end
        when /^fr/i
          upcase_first(word)
			else
				word
			end
		end

	end
end
