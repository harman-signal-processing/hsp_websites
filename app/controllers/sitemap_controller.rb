class SitemapController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_locale, except: :index

  # Dynamically generated sitemap. The @pages variable should end up with
  # an Array of Hashes. Each Hash represents a page on the site and should
  # have the following attributes:
  #   :url        (full url),
  #   :updated_at (a datetime object),
  #   :changefreq ('daily', 'monthly', etc.),
  #   :priority   (decimal ranking priority among other pages in this site alone)
  #
  def show
    @pages = []
    @pages << { url: root_url(locale: nil),
      updated_at: 1.day.ago,
      changefreq: 'daily',
      priority: 1 }
    @pages << { url: locale_root_url,
      updated_at: Date.today,
      changefreq: 'daily',
      priority: 1 }
    @pages << { url: where_to_find_url,
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
        priority: 0.7 } if product.active_retailer_links.length > 0 && !(product.parent_products.size > 0)
    end
    if website.has_software?
      @pages << { url: softwares_url,
        updated_at: 5.days.ago,
        changefreq: 'weekly',
        priority: 0.7 }
      website.current_softwares.each do |software|
        @pages << { url: url_for(software),
          updated_at: software.updated_at,
          changefreq: 'weekly',
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
  end

  # Overall sitemap (links to each locale sitemap)
  def index
    @pages = []
    website.available_locales.each do |l|
      @pages << {
        url: locale_sitemap_url(locale: l.locale.to_s, format: 'xml'),
        updated_at: 1.day.ago}
    end
    respond_to do |format|
      format.html
      format.xml
    end
  end
end
