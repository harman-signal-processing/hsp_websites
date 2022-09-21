class MainController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_locale, except: [:site_info, :favicon]

  # The main site homepage
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
    @news = News.all_for_website(website, limit: news_limit, skip_product_news_query: true)
    begin
      @youtube = website.value_for('youtube').to_s.match(/\w*$/).to_s
    rescue
      @youtube = false
    end
    @features = website.features

    @featured_products = website.featured_products
    @featured_video   = website.featured_video
    @current_promotions = I18n.locale.match(/en|us/i) ? Promotion.current_for_website(website) : []

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

  # Built for the DOD relaunch, replaces the homepage with parralax
  def teaser
    render_template action: 'teaser', layout: teaser_layout
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

  # Generates an RSS feed of the latest News
  def rss
    @title = t('titles.news', brand: website.brand_name)
    @description = website.value_for("default_meta_tag_description")
    @news = News.all_for_website(website)
    respond_to do |format|
      format.xml # render rss.xml.builder
    end
  end

  # Email signup page...actually loads an iframe with a acoustic form inside
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

  def robots
    respond_to do |format|
      format.txt
    end
  end

  def analytics
    @ga = website.value_for('google_analytics_account')
    @add_to_ga = website.value_for('google_analytics_add_email')
    respond_to do |format|
      format.txt {
        unless @ga.present? && @add_to_ga.present?
          render plain: "No email address to add." and return false
        end
      }
    end
  end

  private

  def teaser_layout
    File.exist?(Rails.root.join("app", "views", website.folder, "layouts", "teaser.html.erb")) ?
      "#{website.folder}/layouts/teaser" : "teaser"
  end

end
