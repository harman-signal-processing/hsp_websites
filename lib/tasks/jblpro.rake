namespace :jblpro do

  desc "Importing JBL products"
  task import_products: :environment do

    @root_site = "http://www.jblpro.com"
    @agent = Mechanize.new
    @links_followed = []

    products_index = @agent.get("#{ @root_site }/www/products")

    all_pf_links = products_index.links_with(href: /products/)
    #.collect do |link|
    #  link.href.match(/\#/) ? link.href.gsub!(/\#.*$/, "") : link.href
    #end

    products_index.css(".column-header").each do |top_family_page|
      if top_family_page.css("a").length > 0
        top_family_link = top_family_page.css("a").attr('href').value
        top_family_name = top_family_page.css(".stylized").text.titleize
        puts "Working on top family: #{ top_family_name }"
        top_family = jblpro.product_families.where(name: top_family_name).first_or_create

        child_links = []
        all_pf_links.uniq.each do |link|
          next if link.href == top_family_link
          child_links << link if link.href.match(/#{ top_family_link }/)
        end
        crawl_child_links(child_links, top_family)
      end
    end

    Product.where(brand: jblpro).update_column("layout_class", "vertical")

    puts "JBL product families: #{ jblpro.product_families.count }"

  end

  desc "Manually import one JBL product"
  task import_product: :environment do
    @root_site = "http://www.jblpro.com"
    @agent = Mechanize.new
    @links_followed = []

    ["pro-soundbar"].each do |pid|
      page = @agent.get("http://www.jblpro.com/www/products/installed-sound/#{pid}")
      product_family = ProductFamily.find("commercial-soundbars")

      find_or_create_product(page, product_family)
    end
  end

  desc "Manually crawl one JBL product family"
  task import_family: :environment do
    @root_site = "http://www.jblpro.com"
    @agent = Mechanize.new
    @links_followed = []

    family_page = @agent.get("https://www.jblpro.com/www/products/cinema-market/vip-rooms")
    parent_family = ProductFamily.find "jbl-professional-cinema"

    find_or_create_family(family_page, parent_family)
  end

  desc "Import JBL news"
  task import_news: :environment do
    @root_site = "http://www.jblpro.com"
    @agent = Mechanize.new
    @links_followed = []

    news_article_links = []
    (1..16).each do |page_num|
      news_index = @agent.get("#{ @root_site }/www/news/press-releases/page/#{page_num}")

      news_index.css("li.sfnewsListItem").each do |li|
        news_article_links << li.css("a").attr('href').value
      end
    end

    news_article_links.each do |article_link|
      puts article_link
      @agent.get("#{ @root_site }/www/news/press-releases/page/1")
      article_page = @agent.get(article_link)

      news = News.where(
        brand_id: jblpro.id,
        title: article_page.css("h1.sfnewsTitle").text.strip
      ).first_or_initialize

      news.post_on = article_page.css(".sfnewsAuthorAndDate").text.strip.gsub(/^.*\|+/, "").to_date
      news.old_url = "#{@root_site}#{article_link}"
      news.quote = article_page.css(".sfnewsSummary").text.strip
      article_page.css(".sfnewsContent img").each do |img|
        next unless news.news_photo.blank?
        img_url = img.attr('src')
        fn = img_url.split(/\//).last
        if @agent.get(img_url).save("tmp/#{fn}")
          img_content = File.open("tmp/#{fn}")
          news.news_photo = img_content
          img_content.close
          File.delete("tmp/#{fn}")
        end
      end
      body = article_page.css(".sfnewsContent")
      body.css("img").remove
      news.body = body.inner_html

      news.save
    end
  end

  desc "Importing VERTEC list"
  task import_vertec: :environment do
    @agent = Mechanize.new
    jbl = Brand.find "jbl-professional"

    page = @agent.get("http://www.jblpro.com/catalog/support/vertec-owners-list")
    form = page.form(id: "form1")
    button = form.button_with(value: "Refresh")
    res = form.click_button(button)

    current_region = nil
    current_country = nil
    records =[]

    res.css("table.OwnersListTable").xpath("./tr").each do |row|
      case row.attr('class')
      when "RegionHeaderRow"
        # find or create create region, set current_region
        current_region = row.css("td.RegionHeaderCell").text.strip.gsub(/\A\p{Space}*|\p{Space}*\z/, '')
        current_region.gsub!(/\s{2,}/, ' ')
      when "CountryHeaderRow"
        # find or create country, add it to the current_region and set current_country
        current_country = row.css("td.CountryHeaderCell").text.strip.gsub(/\A\p{Space}*|\p{Space}*\z/, '')
        current_country.gsub!(/\s{2,}/, ' ')
      else
        # If class is blank, it is either a blank row, or actual data
        next if row.css("td.CountryHeaderCellHorizontalRule").length > 0
        # Find or create owner record, add it to the current_country
        record = {
          region: current_region,
          country: current_country
        }
        row.xpath("./td").each do |cell|
          if cell.css("strong").length > 0
            record[:name] = cell.css("strong").text.strip.gsub(/\A\p{Space}*|\p{Space}*\z/, '')
            cell.css("strong").remove
            record[:address] = cell.css("font").inner_html.strip
            record[:address].gsub!(/^<br>/i, '')
            record[:address].gsub(/\A\p{Space}*|\p{Space}*\z/, '')
          elsif cell.css("table").length > 0
            this_label = nil
            cell.css("table td").each do |subcell|
              if subcell.attr('class') == "OwnersListTableLabel"
                this_label = subcell.text.strip.gsub!(/\:/, '').downcase
                this_label = "telephone" if this_label == "phone"
              elsif subcell.xpath("./a").length > 0
                record[this_label.to_sym] = subcell.css("a").text.strip.gsub(/\A\p{Space}*|\p{Space}*\z/, '')
              else
                if this_label == "models"
                  models = subcell.inner_html.strip.gsub(/\A\p{Space}*|\p{Space}*\z/, '').split(/<br>/i)
                  record[:products] = models.join(", ")
                else
                  record[this_label.to_sym] = subcell.text.strip.gsub(/\A\p{Space}*|\p{Space}*\z/, '')
                end
              end
            end
          else
            record[:name2] = cell.text.strip
          end
        end
        record[:rental] = true
        record[:resale] = false
        new_dealer = Dealer.where(record).first_or_create!
        records << new_dealer
        jbl.dealers << new_dealer unless jbl.dealers.include?(new_dealer)
        puts new_dealer.name
      end
    end
    puts "Records found/created: #{records.length}"
  end

  task geocode_vertec: :environment do
    jbl = Brand.find "jbl-professional"

    jbl.dealers.where(rental: true).each do |dlr|
      dlr.geocode_address && dlr.save(validate: false)
      puts dlr.name
      puts "   Lat: #{dlr.lat}, Lng: #{dlr.lng}"
      sleep(30)
    end
  end

  def find_or_create_family(family_page, parent_family = nil)
    #begin
      if family_page.css(".FamilyPageDescription").length > 0
        pf_name = family_page.css(".FamilyPageTitle").text
        intro = family_page.css(".FamilyPageDescription").inner_html
      else # we have one of those fancy new product family pages
        pf_name = family_page.title.gsub(/\|.*/, '').strip
        intro = ""
      end
      if pf_name.blank? && family_page.css(".Header-Orange").length > 0
        pf_name = family_page.css(".Header-Orange").text
      end
      if pf_name.present?
        product_family = ProductFamily.where(name: pf_name.strip, brand: jblpro).first_or_initialize
        product_family.intro = intro
        product_family.save!
        product_family.old_url = family_page.uri

        puts "    created/updated product family: #{ product_family.name }"

        crawl_child_links(family_page.links_with(href: /#{family_page.uri.path}/), product_family)

        if parent_family
          parent_family.children << product_family
        end

        product_family
      else
        log_problem "No family name found. #{ family_page.uri.path }"
      end
    #rescue
    #  log_problem "Welp, some kind of problem at #{ family_page.uri.path }"
    #end
  end

  def find_or_create_product( product_page, parent )
    #begin
      product_name = product_page.css(".ProductPageTitle").text
      if !product_name.present?
        product_name = product_page.css('div[class^="ProductPageTitle_"]').text
      end
      if product_name.present?
        product = Product.where(name: product_name.strip, brand: jblpro).first_or_initialize

        if product.old_url.blank?
          product.short_description ||= product_page.css(".ProductPageTitleDescription").text.strip
          description = product_page.css("#ProductOverview")
          description.css("div.SectionBlackBigText").each do |div|
            div.name = 'h3'
            div.delete('class')
          end
          description.css("div.SectionContentNormal").each do |div|
            div.name = 'p'
            div.delete('class')
          end
          description.xpath('//comment()').remove

          #TODO: Oh, hey, there's also some html with embedded images. So,
          #we'll need to save those off into the new platform. (See the 708P)

          product.description = description.inner_html
          product.features    = product_page.css("#ProductFeatures").inner_html
          product.old_url = product_page.uri

          # Add pricing
          if product_page.css("div.BuyNowPrice").length > 0
            msrp = product_page.css("div.BuyNowPrice span").text.strip.gsub(/\D/, '')
            if msrp.to_i > 0
              product.msrp_cents = msrp.to_i
            end
          else
            product.hide_buy_it_now_button = true
          end

          #TODO: add the "Technology" and "Integration" sections found on some pages
          # (like the 708p), also save and replace the images in those sections' html.
          #
          product.save!
          puts "      created/updated product: #{ product.name.strip }"

          parent.products << product unless parent.products.include?(product)

          # Buy it now links
          product_page.css("div.retailer_logo_link a").each do |bin_link|
            if bin_link[:onclick].match(/\[(.*)\]/)
              retailer_name = $1.split(', ')[2].gsub(/\'/, "")
              unless retailer_name.blank?
                online_retailer = OnlineRetailer.where(name: retailer_name).first_or_create
                orl = OnlineRetailerLink.where(
                  product: product,
                  online_retailer: online_retailer
                ).first_or_initialize
                orl.url = bin_link[:href]
                orl.save
              end
            end
          end

          #NOTE: This is likely working but hasn't been tested. Uncomment
          #the secondary function below to make it actually work
          # Product attachments, etc. (need the product created first)
          product_page.css("#medialibrarywrapper").css("#downloadcontenttext").each do |category|
            category_name = category.css("h3").text.strip
            category.css("a").each do |link|
              if link[:class] == 'youtube'
                if link[:href].to_s.match(/watch\?v\=(.*)$/)
                  video_id = $1
                  unless product.product_videos.pluck(:youtube_id).include?(video_id)
                    ProductVideo.create({
                      product: product,
                      youtube_id: video_id,
                      group: "Product Videos"
                    })
                  end
                end
              else
                title = link.text.strip
                link = Mechanize::Page::Link.new link, @agent, product_page
                fields = {
                  name: title,
                  resource_type: category_name,
                  brand_id: jblpro.id,
                  show_on_public_site: true,
                  is_document: true
                }
                fn = link.uri.path.split(/\//).last
                if fn.present?
                  add_downloads_part_two(product, fields, link.uri, fn)
                end
              end
            end
          end

          #specs = loop through table.SpecsTableRows
          product_page.css("table.SpecsTableRows").css("tr").each do |spec_row|
            spec_name = spec_row.css(".SpecNameColumn").text.strip
            spec_value = spec_row.css(".SpecValueColumn").text.strip
            if spec_name.present? && spec_value.present?
              specification = Specification.where(name: spec_name).first_or_create!
              unless product.specifications.include?(specification)
                ProductSpecification.create!({
                  product: product,
                  specification: specification,
                  value: spec_value
                })
              end
            end
          end

          #NOTE: This is likely working, but hasn't been tested.
          #Uncomment the secondary function below to make it work
          # Add product images
          product_page.css("img.cloudzoom-gallery").each do |img|
            img_url = img[:src].gsub(/([\_\-])t\./, '\1z.')
            unless img_url.blank?
              fn = img_url.split(/\//).last
              puts " ... getting image #{ fn }"
              unless product.product_attachments.pluck(:product_attachment_file_name).include?(fn)
                begin
                  add_one_image_to_product(product, img_url, fn)
                rescue
                  log_problem "Problem adding img #{ img_url } to #{ product.name }"
                end
              end
            end
          end
        end

      else
        log_problem "No product name found here. #{ product_page.uri.path }"
      end
    #rescue
    #  log_problem "Some kind of problem found at #{ product_page.uri.path }"
    #end
  end

  def crawl_child_links(links, parent)
    links.each do |link|
      link_url = "#{ @root_site}#{ link.href }"
      next if @links_followed.include?(link_url)
      begin
        page = @agent.get(link_url)
        @links_followed << link_url
        if page.css("#ProductOverview").length > 0
          puts "   following product link #{ link.href }"
          find_or_create_product( page , parent )
        else
          puts "   following product family link #{ link.href }"
          find_or_create_family( page, parent )
        end
      rescue
        log_problem "Problem with: #{ link_url }"
      end
    end
    sleep(2) # to not overwhelm MBOX servers
  end

  def jblpro
    Brand.find("jbl-professional")
  end

  def add_one_image_to_product(product, img_url, fn)
    begin
      if @agent.get(img_url).save("tmp/#{fn}")
        img = File.open("tmp/#{fn}")
        product.product_attachments << ProductAttachment.new(product_attachment: img)
        img.close
        product.save
        File.delete("tmp/#{fn}")
      end
    rescue Mechanize::ResponseCodeError
      log_problem "Couldn't get image #{img_url}"
    end
  end

  def add_downloads_part_two(product, fields, file_url, fn)
    the_stored_fn = fn.gsub(/\s/, "_")
    if !!(fn.match(/(png|jpg|jpeg|tif|tiff|bmp|gif)$/i))
      se = SiteElement.where(
        brand_id: fields[:brand_id],
        name: fields[:name],
        version: fields[:version],
        language: fields[:language],
        resource_file_name: the_stored_fn
      ).first_or_initialize
    else
      se = SiteElement.where(
        brand_id: fields[:brand_id],
        name: fields[:name],
        version: fields[:version],
        language: fields[:language],
        executable_file_name: the_stored_fn
      ).first_or_initialize
    end

    if se.new_record?
      fields.each do |k,v|
        se[k] = v
      end
      begin
        if @agent.get(file_url).save("tmp/#{fn}")
          download = File.open("tmp/#{fn}")
          if !!(fn.match(/(png|jpg|jpeg|tif|tiff|bmp|gif)$/i))
            se.resource = download
          else
            se.executable = download
          end
          download.close
          se.save
          File.delete("tmp/#{fn}")
        else
          puts "   ERROR getting #{file_url }"
        end
      rescue Mechanize::ResponseCodeError
        log_problem "Couldn't get file #{file_url}"
      end
    end

    se.update_attributes(fields)

    ProductSiteElement.where(product: product, site_element: se).first_or_create
  end

  def log_problem(msg)
    puts msg
    File.open("log/jblimport_problems.txt", 'a') do |f|
      f.puts "#{Time.now.to_s} - #{msg}"
    end
  end
end
