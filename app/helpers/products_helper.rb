module ProductsHelper
  
  def link_to_product_attachment(product_attachment)
    if !product_attachment.product_attachment_file_name.blank?
      img = product_attachment.product_attachment.url(:tiny)
      if product_attachment.no_lightbox?
        new_content = link_to(image_tag(product_attachment.product_attachment.url(:medium), style: "vertical-align: middle"), 
          product_attachment.product_attachment.url)
      else
        new_content = link_to(image_tag(product_attachment.product_attachment.url(:medium), style: "vertical-align: middle"), 
          product_attachment.product_attachment.url(:lightbox), class: "lightbox")
      end
    else
      img = product_attachment.product_media_thumb.url(:tiny) 
      if product_attachment.product_media_file_name.to_s.match(/swf$/i)
        width = (product_attachment.width.blank?) ? "100%" : product_attachment.width
        height = (product_attachment.height.blank?) ? "100%" : product_attachment.height
        new_content = swf_tag(product_attachment.product_media.url, size: "#{width}x#{height}")
      elsif product_attachment.product_media_file_name.to_s.match(/flv|mp4|mov|mpeg|mp3|m4v$/i)
        media_url = request.protocol + request.host_with_port + product_attachment.product_media.url('original', false)
        new_content = render_partial("shared/player", media_url: media_url)
      else
        new_content = product_attachment.product_attachment.url
      end
    end
    link_to_function image_tag(img, style: "vertical-align: middle"), "$('#viewer').html('#{escape_javascript(new_content)}');load_lightbox()"
  end
  
  def tab_title(product_tab, options={})
    title = options[:shorten] ? t("product_page.labels.#{product_tab.key}") : t("product_page.#{product_tab.key}")
    if I18n.locale == I18n.default_locale
      if options[:product] && product_tab.key == "features" && custom_title = options[:product].rename_tab('features')
        title = custom_title
      elsif custom_title = eval("website.#{product_tab.key}_tab_name")
        title = custom_title
      end
    end
    (product_tab.count.to_i > 1) ? "#{product_tab.count} #{title}" : title
  end
  
  def draw_info_boxes(product, options={})
    default_options = {hide_on_load: true}
    options = default_options.merge options
    return discontinued_boxes(product) if product.discontinued?
    ret = ""
    side_tabs = (options[:tabs]) ? parse_tabs(options[:tabs], product) : product.tabs
    side_tabs.each do |product_tab|
      hidden = (options[:hide_on_load]) ? "display: none;" : ""
      ret += "<div id=\"#{product_tab.key}\" class=\"product_detail_box\">" +
        "<h2>" + link_to_function(tab_title(product_tab), "$('##{product_tab.key}_content').toggle()") + "</h2>" +
        content_tag(:div, id: "#{product_tab.key}_content", style: hidden, class: "product_tab_content") do
          render_partial("products/#{product_tab.key}", product: product)
        end
      ret += "</div>"
    end
    raw(ret)
  end
  
  def draw_packaging_boxes(product)
    if product.package_tabs.size > 0
    ret = "<div id='product_packaging_tabs'><ul>"
    hider = product.package_tabs.collect{|t| "$('##{t.key}_content').hide();$('##{t.key}').removeClass('current')"}.join(";")
    product.package_tabs.each_with_index do |product_tab,i|
      current = (i == 0) ? "class='current'" : ""
      # show-er = something that shows, not a place to clean one's body
      shower = "$('##{product_tab.key}_content').show();$('##{product_tab.key}').addClass('current');"
      ret += "<li id=\"#{product_tab.key}\" #{current}>"
      ret += link_to_function(image_tag("#{product_tab.key}_icon.png", alt: "", style: "vertical-align: middle") + tab_title(product_tab, shorten: true), "#{hider};#{shower}") 
      ret += "</li>"
    end
    ret += "<li style=\"color: #666; padding-top: 6px; padding-left: 6px;font-style: oblique\"></li>"
    ret += "</ul></div><div id='product_packaging_contents'>"
    product.package_tabs.each_with_index do |product_tab, i|
      hidden = (i == 0) ? "" : "display: none;"
      ret += content_tag(:div, id: "#{product_tab.key}_content", style: hidden, class: "product_package_content") do
          render_partial("products/#{product_tab.key}", product: product, title: tab_title(product_tab))
        end
    end
    ret += "</div>"
    raw(ret)
    end
  end
  
  # So, these are the tabs that can be clicked on to show the contents
  def draw_main_tabs(product, options={})
    main_tabs = (options[:tabs]) ? parse_tabs(options[:tabs], product) : product.main_tabs
    if main_tabs.size > 1
      ret = "<ul id='product_main_tabs'>"
      main_tabs.each_with_index do |product_tab,i|
        if options[:active_tab]
          current = (product_tab.key == options[:active_tab]) ? "current" : ""
        else
          current = (i == 0) ? "current" : ""
        end
        ret += content_tag(:li, link_to(tab_title(product_tab, product: product), product_path(product, tab: product_tab.key), data: { tabname: product_tab.key }), class: current, id: "#{product_tab.key}_tab")
      end
      ret += "</ul>"
      raw(ret)
    end
  end
  
  # These are the actual main tab contents
  def draw_main_tabs_content(product, options={})
    main_tabs = (options[:tabs]) ? parse_tabs(options[:tabs], product) : product.main_tabs
    ret = ""
    main_tabs.each_with_index do |product_tab,i|
      if options[:active_tab]
        hidden = (product_tab.key == options[:active_tab]) ? "" : "display: none;"
      else
        hidden = (i == 0) ? "" : "display: none;"
      end
      ret += content_tag(:div, id: "#{product_tab.key}_content", style: hidden, class: "product_main_tab_content") do
               render_partial("products/#{product_tab.key}", product: product)
             end
    end
    raw(ret)
  end

  def parse_tabs(tabs, product)
    selected_tabs = tabs.split("|")
    r = []
    r << ProductTab.new("description") if selected_tabs.include?("description")
    r << ProductTab.new("extended_description") if !product.extended_description.blank? && selected_tabs.include?("extended_description")
    r << ProductTab.new("features") if product.features && selected_tabs.include?("features")
    r << ProductTab.new("specifications") if product.product_specifications.size > 0 && selected_tabs.include?("specifications")
    r << ProductTab.new("documentation") if (product.product_documents.size > 0 || product.current_and_recently_expired_promotions.size > 0 || product.viewable_site_elements.size > 0) && selected_tabs.include?("documentation")
    r << ProductTab.new("training_modules") if product.training_modules.size > 0 && selected_tabs.include?("training_modules")
    r << ProductTab.new("downloads_and_docs") if (product.softwares.size > 0 || product.product_documents.size > 0 || product.site_elements.size > 0) && selected_tabs.include?("downloads_and_docs")
    r << ProductTab.new("reviews") if (product.product_reviews.size > 0 || product.artists.size > 0) && selected_tabs.include?("reviews")
    r << ProductTab.new("artists") if product.artists.size > 0 && selected_tabs.include?("artists")
    r << ProductTab.new("tones") if product.tone_library_patches.size > 0 && selected_tabs.include?("tones")
    r << ProductTab.new("news_and_reviews") if product.news_and_reviews.size > 0 && selected_tabs.include?("news_and_reviews")
    r << ProductTab.new("downloads") if (product.softwares.size > 0 || product.site_elements.size > 0 || product.executable_site_elements.size > 0) && selected_tabs.include?("downloads")
    r << ProductTab.new("gallery") if product.images_for("product_page").size > 0 && selected_tabs.include?("gallery")
    r << ProductTab.new("news") if product.current_news.size > 0 && selected_tabs.include?("news")
    r << ProductTab.new("support") if selected_tabs.include?("support")
    r
  end

  # Shows the HTML5 audio demos for this product
  def draw_audio_demos(product)
    ret = ""
    if product.audio_demos.size > 0
    # ret += '<div id="sm2-container"></div>'
    ret += "<h3>Audio Demos</h3>"
    ret += '<ul class="graphic">'
    product.audio_demos.each do |audio_demo|
      ret += content_tag(:li, link_to(audio_demo.name, audio_demo.wet_demo.url, class: "sm2_link"))
    end
    ret += "</ul>"
    end
    raw(ret)
  end

  def discontinued_boxes(product)
    ret = ""
    rendered_tab_names = []
    tabs = product.main_tabs + product.tabs
    tabs.each do |product_tab|
      next if product_tab.key == 'description' || product_tab.key == 'extended_description' # these already appear in the view
      next if rendered_tab_names.include?(product_tab.key)
      ret += "<div id=\"#{product_tab.key}\" class=\"product_detail_box\">" +
        "<h2>" + tab_title(product_tab) + "</h2>" +
        content_tag(:div, id: "#{product_tab.key}_content") do
          render_partial("products/#{product_tab.key}", product: product)
        end
      ret += "</div>"
      rendered_tab_names << product_tab.key
    end
    raw(ret)
  end
  
  def buy_it_now_link(product, options={})
    if !product.discontinued?

      default_options = {button_prefix: ""}
      options = default_options.merge options
      button = button_for(product, options)

		  if !product.in_production?
        no_buy_it_now(product)
      elsif product.hide_buy_it_now_button?
        ""
		  elsif !session["geo_usa"] || I18n.locale != I18n.default_locale
        buy_it_now_international(product, button)
		  elsif !product.direct_buy_link.blank?
        buy_it_now_direct_from_factory(product, button)
      elsif @online_retailer_link # http param[:bin] provided
        buy_it_now_direct_to_retailer(product, button)
		  else
        buy_it_now_usa(product, button)
		  end
		end    
  end

  def folder_for(product)
    (product.layout_class.to_s.match(/vocalist/)) ? product.layout_class : website.folder
  end

  def button_for(product, options)
    folder = folder_for(product)
    if product.direct_buy_link.blank?
      image_tag("#{folder}/#{I18n.locale}/#{options[:button_prefix]}buyitnow_button.png", alt: t("online_dealers_us"), mouseover: "#{folder}/#{I18n.locale}/#{options[:button_prefix]}buyitnow_button_hover.png")
    elsif product.parent_products.size > 0 # as in e-pedals
      image_tag("#{folder}/#{I18n.locale}/#{options[:button_prefix]}getit_button.png", alt: t("online_dealers_us"), mouseover: "#{folder}/#{I18n.locale}/#{options[:button_prefix]}getit_button_hover.png")
    else
      image_tag("#{folder}/#{I18n.locale}/#{options[:button_prefix]}addtocart_button.png", alt: t("online_dealers_us"), mouseover: "#{folder}/#{I18n.locale}/#{options[:button_prefix]}addtocart_button_hover.png")
    end
  end

  def no_buy_it_now(product)
    folder = folder_for(product)
    if product.show_on_website?(website)
      image_tag("#{folder}/#{I18n.locale}/coming_soon.png", alt: "coming soon")
    else
      image_tag("#{folder}/#{I18n.locale}/confidential.png", alt: "confidential")
    end    
  end

  def buy_it_now_usa(product, button)
    if product.active_retailer_links.size > 0
      # tracker = (Rails.env.production?) ? "_gaq.push(['_trackEvent', 'BuyItNow', 'USA', '#{product.name}']);" : ""
      # link_to_function button, "#{tracker}popup('dealer_popup');"
      link_to(button, 
        buy_it_now_product_path(product), 
        class: "buy_it_now_popup", 
        data: {windowname: 'dealer_popup'},
        onclick: raw("_gaq.push(['_trackEvent', 'BuyItNow', 'USA', '#{product.name}'])"))
    else
      link_to(button, 
        where_to_buy_path, 
        onclick: raw("_gaq.push(['_trackEvent', 'BuyItNow', 'Without online retailer links', '#{product.name}'])"))
    end
  end

  def buy_it_now_direct_to_retailer(product, button)
    link_to(button, 
      @online_retailer_link.url, 
      target: "_blank", 
      onclick: raw("_gaq.push(['_trackEvent', 'BuyItNow-Dealer', '#{@online_retailer_link.online_retailer.name}', '#{product.name}'])"))
  end

  def buy_it_now_direct_from_factory(product, button)
    link_to(button, 
      product.direct_buy_link, 
      target: "_blank", 
      onclick: raw("_gaq.push(['_trackEvent', 'AddToCart', 'USA (#{session['geo_country']})', '#{product.name}'])"))
  end

  def buy_it_now_international(product, button)
    link_to(button, 
      international_distributors_path, 
      onclick: raw("_gaq.push(['_trackEvent', 'BuyItNow', 'non-USA (#{session['geo_country']})', '#{product.name}'])"))
  end
  
  def links_to_current_promotions(product, options={})
    format = options[:format] || "full"
    begin
      if product.current_promotions.size == 1
        promo = product.current_promotions.first
        alt_url = (promo.promo_form_file_name.blank?) ? promotions_path : promo.promo_form.url
        if format == "text_only"
          content_tag(:div, link_to(promo.name, (promo.has_description?) ? promo : alt_url))
        else
          content_tag(:h2, class: "special_offer") {
            link_to(t('product_page.special_offer'), (promo.has_description?) ? promo : alt_url)
          } + content_tag(:div, class: "special_offer_contents") {
            link_to(promo.name, (promo.has_description?) ? promo : alt_url)
          }
        end
      elsif product.current_promotions.size > 1
        if format == "text_only"
          content_tag(:div, link_to(t('product_page.specal_offer'), promotions_path))
        else
          content_tag(:h2, class: "special_offer") {
            link_to(t('product_page.special_offer'), promotions_path)
          }
        end
      end
    rescue 
      ""
    end
  end
  
  def breadcrumbs(product)
    crumbs = []
    crumbs << link_to(t('products'), product_families_path)
    product.product_families.where(brand_id: website.brand_id).includes(:products, :parent).each do |pf|
      crumbs << link_to(translate_content(pf.parent, :name).downcase, pf.parent) if pf.parent && pf.parent.locales(website).include?(I18n.locale.to_s)
      unless pf.current_products.size < 2
        crumbs << link_to(strip_html(translate_content(pf, :name)).downcase, pf) if pf.locales(website).include?(I18n.locale.to_s)
      end
    end
    raw("#{t(:back_to)} #{crumbs.uniq.join(" :: ")}")
  end

  # Figure out which is the image path for the toggle effect on
  def effect_on_image_path(product)
    images = product.images_for("product_page")
    if images.size >= 3
      images[2].product_attachment.url(:epedal)
    else
      product.photo.product_attachment.url(:epedal)
    end
  end

  # Weird sorting for the epedal coverflow. Puts the first pedals in the middle
  # and goes out from there.
  def coverflow_shuffle(c)
    evens = []
    c.each_with_index {|p,i| evens << p if i.even? }
    evens.reverse + (c - evens)
  end
  
  # Used to call directly from the Swf_fu gem, but rails 3.2 only works if it
  # is here:
  def swf_tag(source, options={}, &block)
    ActionView::Helpers::SwfFuHelper::Generator.new(source, options, self).generate(&block)
  end

  # Returns a checkmark if the specification value is "yes"
  def spec_value(val)
    (val.match(/^yes\s*?$/i)) ? image_tag("check.png", alt: val) : val
  end
  
end
