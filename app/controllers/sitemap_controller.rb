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
    respond_to do |format|
      format.html
      format.xml {
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
        if website.brand.has_product_selector?
          @pages << { url: product_selector_url,
            updated_at: 1.day.ago,
            changefreq: 'daily',
            priority: 0.9 }
          ProductFamily.parents_with_current_products(website, I18n.locale).select do |pf|
            unless pf.product_selector_behavior.to_s == "exclude"
              @pages << { url: product_selector_product_family_url(pf),
                updated_at: 3.days.ago,
                changefreq: 'weekly',
                priority: 0.8 }
            end
          end
        end
        pf_count = 0
        ProductFamily.all_with_current_products(website, I18n.locale).each do |product_family|
          unless product_family.preview_password.present?
            if product_family.hreflangs(website).include?(I18n.locale.to_s) &&
              (product_family.features.length > 0 || product_family.current_products_plus_child_products(website).length > 1)
              @pages << { url: url_for(product_family),
                updated_at: product_family.updated_at,
                changefreq: 'weekly',
                priority: 0.9 }
              pf_count += 1
              if website.brand.has_product_selector? && product_family.product_selector_behavior == "subgroup"
                @pages << { url: product_selector_subfamily_product_selector_product_family_url(product_family.parent, product_family),
                  updated_at: 4.days.ago,
                  changefreq: 'weekly',
                  priority: 0.7 }
              end
            end
          end
        end
        if pf_count > 0
          @pages << { url: product_families_url,
            updated_at: 1.day.ago,
            changefreq: 'weekly',
            priority: 1 }
          @pages << { url: discontinued_products_url,
            updated_at: 1.month.ago,
            changefreq: 'monthly',
            priority: 0.2 }
        end
        Product.all_for_website(website).each do |product|
          unless @product.product_page_url.present?
            if product.hreflangs(website).include?(I18n.locale.to_s)
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
              # 2024-09-25 AA removed from sitemap since these links almost always redirect to where to buy page
              #@pages << { url: buy_it_now_product_url(product),
              #  updated_at: product.updated_at,
              #  changefreq: 'weekly',
              #  priority: 0.7 } if product.active_retailer_links.length > 0 && !(product.parent_products.size > 0)
            end
          end
        end
        if website.has_software?
          @pages << { url: softwares_url,
            updated_at: 5.days.ago,
            changefreq: 'weekly',
            priority: 0.7 }
          website.current_softwares.each do |software|
            if software.has_additional_info?
              @pages << { url: url_for(software),
                updated_at: software.updated_at,
                changefreq: 'weekly',
                priority: 0.8 }
            end
          end
        end
        all_news = News.all_for_website(website)
        if all_news.size > 0
          @pages << { url: news_index_url,
            updated_at: all_news.order('created_at DESC').first.updated_at,
            changefreq: 'weekly',
            priority: 0.8 }
          all_news.each do |news|
            if news.hreflangs(website).include?(I18n.locale.to_s)
              @pages << { url: url_for(news),
                updated_at: news.updated_at,
                changefreq: 'monthly',
                priority: 0.7 }
            end
          end
        end
        begin
          case_studies = CaseStudy.find_by_website_or_brand(website)
          if case_studies.size > 0
            @pages << { url: case_studies_url,
              updated_at: 1.hour.ago,
              changefreq: 'daily',
              priority: 0.8 }
            case_studies.each do |case_study|
              @pages << { url: case_study_url(case_study[:slug]),
                updated_at: case_study[:updated_at].to_time,
                changefreq: 'monthly',
                priority: 0.7 }
            end
            case_study_vertical_markets = case_studies.map{|cs| cs[:vertical_markets]}.flatten.uniq.sort_by{|v| v[:name]}.select{|v| v[:live] == true}
            case_study_vertical_markets.each do |csvm|
              @pages << { url:  case_studies_by_vertical_market_url(csvm[:slug]),
                updated_at: 1.week.ago,
                changefreq: 'weekly',
                priority: 0.5 }
            end
          end
        rescue
          # if there was a problem loading case studies, move on
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
          unless page.requires_login? || page.exclude_from_search?
            purl = (!page.custom_route.blank?) ? "#{locale_root_url}/#{page.custom_route}" : url_for(page)
            @pages << { url: purl,
              updated_at: page.updated_at,
              changefreq: 'weekly',
              priority: 0.6 }
          end
        end
      }
    end
  end

  # Overall sitemap (links to each locale sitemap)
  def index
    @pages = []
    website.available_locales.each do |l|
      @pages << {
        url: locale_sitemap_url(locale: l.locale.to_s, format: 'xml'),
        name: "#{l.name} sitemap",
        updated_at: 1.day.ago}
    end
    respond_to do |format|
      format.html
      format.xml
    end
  end
end
