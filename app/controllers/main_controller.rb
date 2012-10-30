class MainController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :set_locale, except: [:default_locale, :sitemap, :site_info, :favicon]
  
  # The main site homepage
  #
  def index
    @news = News.all_for_website(website, limit: 4)
    begin
      @youtube = website.value_for('youtube').to_s.match(/\w*$/).to_s
    rescue
      @youtube = false
    end
    @features = website.features
    respond_to do |format|
      format.html { render_template }
      format.xml { 
        product_families = ProductFamily.parents_with_current_products(website, I18n.locale)
        current_promotions = Promotion.all_for_website(website)
        render xml: product_families + @news + current_promotions 
      }
    end
  end
  
  # The site's dealer locator. You were expecting more code?
  #
  def where_to_buy
    @page_title = t('titles.where_to_buy')
    @err = ""
    @results = []
    unless session['geo_usa']
      redirect_to international_distributors_path and return
    end
    if params[:zip]
      session[:zip] = params[:zip]
      @page_title += " " + t('near_zipcode', zip: params[:zip])
      begin
        @results = []
        # Dealer.find(:all, origin: params[:zip], order: 'distance', within: 15, limit: 10).each do |d|
        count = 0
        origin = Geokit::Geocoders::MultiGeocoder.geocode(params[:zip])
        brand_id = website.dealers_from_brand_id || website.brand_id
        Dealer.near(origin: origin, within: 60).where(brand_id: brand_id).order("distance ASC").all.each do |d|
          unless count > 15 || d.exclude?
            @results << d
            count += 1
          end
        end
        unless @results.size > 0
          @err = t('errors.no_dealers_found', zip: params[:zip])
        end
         @js_map_loader = "map_init('#{@results.first.lat}','#{@results.first.lng}',12,false)"    
      rescue
        redirect_to(where_to_buy_path, alert: t('errors.geocoding')) and return false
      end
    end
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
    ferret_results = ThinkingSphinx.search(
      params[:query], 
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
  
  # The root url routes here. This will render a page where the user can 
  # select the locale (based on the available locales for the current Website).
  # If only one locale is available, then it forwards to the homepage for that
  # locale.
  #
  def default_locale
    if website.show_locales?
      render_template(action: "locale_selector", layout: "locale")
    else
      I18n.locale = website.locale
      redirect_to locale_root_path and return false
    end
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
    ProductFamily.all_with_current_products(website, I18n.locale).each do |product_family|
      @pages << { url: url_for(product_family), 
        updated_at: product_family.updated_at,
        changefreq: 'weekly',
        priority: 0.9 }
    end
    Product.all_for_website(website).each do |product|
      @pages << { url: url_for(product),
        updated_at: product.updated_at,
        changefreq: 'weekly',
        priority: 0.9 }
      @pages << { url: buy_it_now_product_url(product),
        updated_at: product.updated_at,
        changefreq: 'weekly',
        priority: 0.7 } if product.active_retailer_links.length > 0 && !(product.parent_products.count > 0)
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
        priority: 0.2 }
    end
    end
    Page.all_for_website(website).each do |page|
      purl = (!page.custom_route.blank?) ? "#{locale_root_url}/#{page.custom_route}" : url_for(page)
      @pages << { url: purl,
        updated_at: page.updated_at,
        changefreq: 'weekly',
        priority: 0.6 }
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
    custom = Rails.root.join("public", "#{website.folder}.ico")
    if File.exists?(custom)
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

end
