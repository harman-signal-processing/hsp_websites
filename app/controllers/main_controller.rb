class MainController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :set_locale, except: [:sitemap, :site_info, :favicon]
  
  # The main site homepage
  #
  def index
    @counter = website.brand.increment_homepage_counter # reset daily
    events = website.value_for('countdown_next_event')
    @next_event = ''
    if events
      events.split(',').reverse.each do |d|
        @next_event = d if d.to_date > Date.today
      end
    end
    @countdown_container = website.value_for('countdown_container')
    news_limit = website.homepage_news_limit || 4
    @news = News.all_for_website(website, limit: news_limit)
    begin
      @youtube = website.value_for('youtube').to_s.match(/\w*$/).to_s
    rescue
      @youtube = false
    end
    @features = website.features

    @featured_products = website.featured_products
    @featured_video   = website.featured_video
    @current_promotions = Promotion.current_for_website(website)

    respond_to do |format|
      format.html { 
        campaign = "#{website.brand.name}-#{Date.today.year}"
        if website.teaser.to_i >= 1 && !(cookies[campaign])
          teaser
        else
          render_template 
        end
      }
      format.xml { 
        product_families = ProductFamily.parents_with_current_products(website, I18n.locale)
        current_promotions = Promotion.all_for_website(website)
        render xml: product_families + @news + current_promotions 
      }
    end
  end

  # Built for the DOD relaunch, replaces the homepage
  def teaser2
    @signup = Signup.new(campaign: "#{website.brand.name}-#{Date.today.year}")
    render_template action: 'teaser2', layout: "#{website.folder}/layouts/teaser2"
  end

  # Built for the DOD relaunch, replaces the homepage with parralax
  def teaser
    @signup = Signup.new(campaign: "#{website.brand.name}-#{Date.today.year}")
    render_template action: 'teaser', layout: teaser_layout
  end

  def teaser_complete
    render_template action: 'teaser_complete', layout: teaser_layout
  end
  
  # The site's dealer locator. 
  # TODO: Test to see if a dealer's flagged as excluded during SQL query instead of after SQL query
  #
  def where_to_buy
    @page_title = t('titles.where_to_buy')
    @err = ""
    @results = []
    unless session['geo_usa']
      redirect_to international_distributors_path and return
    end
    @us_regions = website.brand.us_regions_for_website
    @us_region = UsRegion.new
    if params[:zip]
      session[:zip] = params[:zip]
      @page_title += " " + t('near_zipcode', zip: params[:zip])
      begin
        @results = []
        count = 0
        brand = Brand.find(website.dealers_from_brand_id || website.brand_id)
        zip = (params[:zip].to_s.match(/^\d*$/)) ? "zipcode #{params[:zip]}" : params[:zip]

        origin = Geokit::Geocoders::MultiGeocoder.geocode(zip)
        brand.dealers.near(origin: origin, within: 60).order("distance ASC").all.each do |d|
          unless count > 15 || d.exclude?
            @results << d
            count += 1
          end
        end

        # @results = brand.dealers.limit(20) # for testing

        unless @results.size > 0
          @err = t('errors.no_dealers_found', zip: params[:zip])
        end
         @js_map_loader = "map_init('#{@results.first.lat}','#{@results.first.lng}',12,false)"    
      rescue
        redirect_to(where_to_buy_path, alert: t('errors.geocoding')) and return false
      end
    end
    @countries = Distributor.countries(website)
    @country = nil
    render_template
  end
  
  # Simple community start page. This could redirect to a phpBB folder
  # or an external site--or it could do nothing and simply render the
  # corresponding view.
  def community
    render_template
  end
  
  # The site's search engine:
  # TODO: Figure out how to search on related fields (ProductDocument.product.name)
  def search
    @page_title = t('titles.search_results')
    @query = params[:query]
    query = @query.to_s.gsub(/[\/\\]/, " ")
    ferret_results = ThinkingSphinx.search(
      Riddle.escape(query), 
      page: params[:page], 
      per_page: 10
    )
    # Probably not the best way to do this, strip out Products from the
    # search results unless the status is set to 'show_on_website'. It
    # would be better to filter these out during the ActsAsFerret.find
    # above, but since this is a multi-model search, there doesn't seem
    # to be a way to do SQL filtering on just one of the models being
    # searched.
    @results = []
    ferret_results.each do |r|
      unless (r.is_a?(Product) && !r.show_on_website?(website)) || 
        (r.has_attribute?(:brand_id) && r.brand_id != website.brand_id) ||
        (r.respond_to?(:belongs_to_this_brand?) && !r.belongs_to_this_brand?(website)) ||
        (r.is_a?(Artist) && !r.belongs_to_this_brand?(website))
        @results << r
      end
    end
    render_template
  end
  
  # The root url routes here. This just redirects to the homepage, but
  # it does so after going through the set_locale filter, allowing us to
  # keep the URL structure consistent. And, that filter will render a locale
  # selector page if multiple locales are available and none can be determined
  # automatically.
  #
  def default_locale
    redirect_to locale_root_path, status: :moved_permanently and return false
  end
  
  # Dynamically generated sitemap. The @pages variable should end up with
  # an Array of Hashes. Each Hash represents a page on the site and should
  # have the following attributes:
  #   :url        (full url), 
  #   :updated_at (a datetime object), 
  #   :changefreq ('daily', 'monthly', etc.), 
  #   :priority   (decimal ranking priority among other pages in this site alone)
  #
  def locale_sitemap
    @pages = []
    @pages << { url: locale_root_url, 
      updated_at: Date.today, 
      changefreq: 'daily', 
      priority: 1 }
    @pages << { url: where_to_buy_url,
      updated_at: Date.today,
      changefreq: 'daily',
      priority: 0.7 } if website.has_where_to_buy?
    @pages << { url: support_url,
      updated_at: 1.day.ago,
      changefreq: 'weekly',
      priority: 0.7 }
    ProductFamily.all_with_current_products(website, I18n.locale).each do |product_family|
      @pages << { url: url_for(product_family), 
        updated_at: product_family.updated_at,
        changefreq: 'weekly',
        priority: 0.9 }
    end
    Product.all_for_website(website).each do |product|
      if product.discontinued?
        @pages << { url: url_for(product),
          updated_at: product.updated_at,
          changefreq: 'monthly',
          priority: 0.6 }
      else
        @pages << { url: url_for(product),
          updated_at: product.updated_at,
          changefreq: 'weekly',
          priority: 0.9 }
      end
      @pages << { url: buy_it_now_product_url(product),
        updated_at: product.updated_at,
        changefreq: 'weekly',
        priority: 0.7 } if product.active_retailer_links.length > 0 && !(product.parent_products.count > 0)
    end
    if website.has_software?
      @pages << { url: softwares_url,
        updated_at: 5.days.ago,
        changefreq: 'weekly',
        priority: 0.7 }
      website.current_softwares.each do |software|
        @pages << { url: url_for(software),
          updated_at: software.updated_at,
          changefrequ: 'weekly',
          priority: 0.8 }
      end
    end
    News.all_for_website(website).each do |news|
      @pages << { url: url_for(news),
        updated_at: news.updated_at,
        changefreq: 'monthly',
        priority: 0.7 }
    end
    if website.has_artists?
      Artist.all_for_website(website).each do |artist|
        @pages << { url: url_for(artist),
          updated_at: artist.updated_at,
          changefreq: 'monthly',
          priority: 0.4 }
      end
    end
    Page.all_for_website(website).each do |page|
      unless page.requires_login?
        purl = (!page.custom_route.blank?) ? "#{locale_root_url}/#{page.custom_route}" : url_for(page)
        @pages << { url: purl,
          updated_at: page.updated_at,
          changefreq: 'weekly',
          priority: 0.6 }
      end
    end
    render "sitemap"
  end
  
  # Overall sitemap (links to each locale sitemap)
  def sitemap
    @pages = []
    @pages << { url: root_url(locale: nil),
      updated_at: 1.day.ago,
      changefreq: 'daily',
      priority: 1 }
    website.available_locales.each do |l|
      @pages << { url: locale_sitemap_url(locale: l.locale.to_s, format: 'xml'),
        updated_at: 1.day.ago,
        changefreq: 'daily',
        priority: 0.8 }
    end
  end
  
  # Generates an RSS feed of the latest News
  def rss
    @title = t('titles.news', brand: website.brand_name)
    @description = website.value_for("default_meta_tag_description")
    @news = News.all_for_website(website)
    respond_to do |format|
      format.xml # render rss.xml.builder
    end
  end
  
  # Email signup page...actually loads an iframe with a silverpop form inside
  def email_signup
    email = params[:Email] || params[:email] || ""
    @src = "#{website.email_signup_url}#{email}"
    @page_title = "Newsletter Sign Up"
    render_template
  end
  
  # Helps to know what site a particular URL is loading:
  def site_info
    render inline: "<pre><%= website.to_yaml %></pre>", layout: false
  end
  
  # Find and deliver the appropriate favicon.ico file which is used by
  # browsers in the URL bar, etc.
  # /favicon.ico
  def favicon
    if website
      custom = Rails.root.join("public", "#{website.folder}.ico")
    end
    if website && File.exists?(custom)
      send_file custom, filename: 'favicon.ico', disposition: 'inline', type: "image/x-icon"
    else
      send_file Rails.root.join("public", "harman.ico"), filename: 'favicon.ico', disposition: 'inline', type: "image/x-icon"
    end
  end
  
  # /channel.html (used for facebook API)
  def channel
    render inline: '<script src="//connect.facebook.net/en_US/all.js"></script>', layout: false
  end
  caches_page :channel

  private

  def teaser_layout
    File.exist?(Rails.root.join("app", "views", website.folder, "layouts", "teaser.html.erb")) ?
      "#{website.folder}/layouts/teaser" : "teaser"
  end

end
