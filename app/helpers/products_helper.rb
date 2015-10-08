module ProductsHelper

  # Using zurb foundation to show the product images
  #
  def interchange_product_image(product)
    q = []

    q << "[#{product.photo.product_attachment.url(:medium)}, (default)]"
    q << "[#{product.photo.product_attachment.url(:large)}, (only screen and (min-width: 1350px))]"
    q << "[#{product.photo.product_attachment.url(:medium)}, (only screen and (min-width: 1024px) and (max-width: 1349px))]"
    q << "[#{product.photo.product_attachment.url(:small)}, (only screen and (max-width: 768px))]"

    image_tag(product.photo.product_attachment.url(:medium),
      data: { interchange: q.join(", ") })
  end

  # Zurb's abide way of doing the lightbox image links
  #
  def abide_link_to_product_attachment(product_attachment)
    if !product_attachment.product_attachment_file_name.blank?
      link_to(image_tag(product_attachment.product_attachment.url(:tiny_square), style: "vertical-align: middle"),
          product_attachment.product_attachment.url)
    else
      img = product_attachment.product_media_thumb.url(:tiny)
      if product_attachment.product_media_file_name.to_s.match(/swf$/i)
        width = (product_attachment.width.blank?) ? "100%" : product_attachment.width
        height = (product_attachment.height.blank?) ? "100%" : product_attachment.height
        new_content = swf_tag(product_attachment.product_media.url, size: "#{width}x#{height}")
      elsif product_attachment.product_media_file_name.to_s.match(/flv|mp4|mov|mpeg|mp3|m4v$/i)
        # At one point, I prepended the protocol and host. Not sure why, but I'm trying it without
        # this to see if I can get it to come through the Amazon cloudfont CDN. (10/2013)
        # media_url = request.protocol + request.host_with_port + product_attachment.product_media.url('original', false)

        new_content = render_partial("shared/player", media_url: product_attachment.product_media.url)
      else
        new_content = product_attachment.product_attachment.url
      end
      link_to_function image_tag(img, style: "vertical-align: middle"), "$('#viewer').html('#{escape_javascript(new_content)}')"
    end
  end

  def link_to_product_attachment(product_attachment)
    if product_attachment.product_attachment_file_name.present?
      link_to product_attachment.product_attachment.url(:original),
        data: product_attachment.no_lightbox? ? {} : { lightbox: 'product-thumbnails' } do
          image_tag(product_attachment.product_attachment.url(:tiny), style: 'vertical-align: middle')
      end
    else
      img = product_attachment.product_media_thumb.url(:tiny)
      if product_attachment.product_media_file_name.to_s.match(/swf$/i)
        width = (product_attachment.width.blank?) ? "100%" : product_attachment.width
        height = (product_attachment.height.blank?) ? "100%" : product_attachment.height
        new_content = swf_tag(product_attachment.product_media.url, size: "#{width}x#{height}")
      elsif product_attachment.product_media_file_name.to_s.match(/flv|mp4|mov|mpeg|mp3|m4v$/i)
        # At one point, I prepended the protocol and host. Not sure why, but I'm trying it without
        # this to see if I can get it to come through the Amazon cloudfont CDN. (10/2013)
        # media_url = request.protocol + request.host_with_port + product_attachment.product_media.url('original', false)

        new_content = render_partial("shared/player", media_url: product_attachment.product_media.url)
      else
        new_content = product_attachment.product_attachment.url
      end
      link_to_function image_tag(img, style: "vertical-align: middle"), "$('#viewer').html('#{escape_javascript(new_content)}')"
    end
  end

  def tab_title(product_tab, options={})
    title = options[:shorten] ? t("product_page.labels.#{product_tab.key}") : t("product_page.#{product_tab.key}")
    if I18n.locale == I18n.default_locale || I18n.locale.to_s.match(/en/)
      if options[:product] && custom_title = options[:product].rename_tab(product_tab.key)
        title = custom_title
      elsif custom_title = eval("website.#{product_tab.key}_tab_name")
        title = custom_title
      end
    end
    (product_tab.count.to_i > 1) ? "#{product_tab.count} #{title}" : title
  end

  # Zurb's way of doing the accordion I had previously hand-written
  #
  def draw_info_accordion(product, options={})
    acc = ""
    side_tabs = (options[:tabs]) ? parse_tabs(options[:tabs], product) : product.tabs

    side_tabs.each_with_index do |product_tab, i|
      active = "active" if i == 0
      title = link_to(tab_title(product_tab), "##{product_tab.key}")
      content = content_tag(:div, id: product_tab.key, class: "content #{active}") do
        render_partial("products/#{product_tab.key}", product: product)
      end
      acc += content_tag(:dd, class: "accordion-navigation") do
        title + content
      end
    end

    content_tag(:dl,
      acc.html_safe,
      class: "accordion",
      data: {accordion: true})
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
      ret += link_to_function(image_tag("icons/#{product_tab.key}_icon.png", alt: "", style: "vertical-align: middle") + tab_title(product_tab, shorten: true), "#{hider};#{shower}") 
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
      ret = options[:zurb] ? "<dl class='tabs' data-tab>" : "<ul id='product_main_tabs'>"
      main_tabs.each_with_index do |product_tab,i|
        if options[:active_tab]
          current = (product_tab.key == options[:active_tab]) ? "active current" : ""
        else
          current = (i == 0) ? "active current" : ""
        end
        if options[:zurb]
          ret += content_tag(
            :dd,
            link_to(
              tab_title(product_tab, product: product),
              "##{product_tab.key}_content",
            ),
            class: current
          )
        else
          ret += content_tag(:li, link_to(tab_title(product_tab, product: product), product_path(product, tab: product_tab.key), data: { tabname: product_tab.key }), class: current, id: "#{product_tab.key}_tab")
        end
      end
      ret += options[:zurb] ? "</dl>" : "</ul>"
      raw(ret)
    end
  end

  # These are the actual main tab contents
  def draw_main_tabs_content(product, options={})
    main_tabs = (options[:tabs]) ? parse_tabs(options[:tabs], product) : product.main_tabs

    ret = "<div class=\"section-container tabs-content\">"

    main_tabs.each_with_index do |product_tab,i|

      if options[:zurb]

        if options[:active_tab]
          active_class = (product_tab.key == options[:active_tab]) ? "active" : ""
        else
          active_class = (i == 0) ? "active" : ""
        end

        ret += content_tag(:div, id: "#{product_tab.key}_content", class: "product_main_tab_content content #{active_class}") do
          render_partial("products/#{product_tab.key}", product: product)
        end

      else

        if options[:active_tab]
          hidden = (product_tab.key == options[:active_tab]) ? "" : "display: none;"
        else
          hidden = (i == 0) ? "" : "display: none;"
        end

        ret += content_tag(:div, id: "#{product_tab.key}_content", style: hidden, class: "product_main_tab_content") do
          render_partial("products/#{product_tab.key}", product: product)
        end

      end
    end

    ret += "</div>"
    raw(ret)
  end

  def draw_side_nav(product, options={})
    main_tabs = (options[:tabs]) ? parse_tabs(options[:tabs], product) : product.main_tabs
    if main_tabs.size > 1
      ret = "<div class='side-nav-container' data-magellan-expedition='static'>"
      ret += "<dl class='side-nav'>"
      main_tabs.each_with_index do |product_tab,i|
        if options[:active_tab]
          current = (product_tab.key == options[:active_tab]) ? "active" : ""
        else
          current = (i == 0) ? "active" : ""
        end
        ret += content_tag(
          :dd,
          link_to(
            tab_title(product_tab, product: product),
            "##{product_tab.key}",
          ),
          class: current,
          data: {
            :'magellan-arrival' => product_tab.key
          }
        )
      end
      ret += "</dl>"
      ret += "</div>"
      raw(ret)
    end
  end

  def draw_top_subnav(product, options={})
    main_tabs = (options[:tabs]) ? parse_tabs(options[:tabs], product) : product.main_tabs
    top_tabs = main_tabs.select do |t|
      t unless t.key.to_s.match(/feature|news|training|support|spec/i)
    end
    if top_tabs.size > 1
      ret = "<div class='top-subnav-container' data-magellan-expedition='fixed'>"
      ret += "<dl class='sub-nav'>"
      top_tabs.each_with_index do |product_tab,i|
        if options[:active_tab]
          current = (product_tab.key == options[:active_tab]) ? "active" : ""
        else
          current = (i == 0) ? "active" : ""
        end
        tt = tab_title(product_tab, product: product)
        tt.gsub!(/Specifications?/, "Specs")
        tt.gsub!(/Documentation/, "Docs")
        ret += content_tag(
          :dd,
          link_to(
            tt,
            "##{product_tab.key}",
          ),
          class: current,
          data: {
            :'magellan-arrival' => product_tab.key
          }
        )
      end
      ret += "</dl>"
      ret += "</div>"
      raw(ret)
    end
  end

  def draw_main_product_content(product, options={})
    main_tabs = (options[:tabs]) ? parse_tabs(options[:tabs], product) : product.main_tabs

    ret = ""

    main_tabs.each_with_index do |product_tab,i|

      if options[:active_tab]
        active_class = (product_tab.key == options[:active_tab]) ? "active" : ""
      else
        active_class = (i == 0) ? "active" : ""
      end

      if i > 0
        ret += link_to('', '', name: product_tab.key)
        ret += content_tag(
          :h3,
          tab_title(product_tab, product: product),
          class: 'content-nav',
          data: {:'magellan-destination' => product_tab.key}
        )
      end
      ret += content_tag(:div, class: "product_main_tab_content content #{active_class}") do
        render_partial("products/#{product_tab.key}", product: product)
      end
    end

    raw(ret)
  end

  def parse_tabs(tabs, product)
    selected_tabs = tabs.split("|")
    r = []
    begin
      r << ProductTab.new("description") if selected_tabs.include?("description")
      r << ProductTab.new("extended_description") if !product.extended_description.blank? && selected_tabs.include?("extended_description")
      r << ProductTab.new("documentation") if (product.product_documents.size > 0 || product.current_and_recently_expired_promotions.size > 0 || product.viewable_site_elements.size > 0) && selected_tabs.include?("documentation")
      r << ProductTab.new("downloads") if (product.softwares.size > 0 || product.site_elements.size > 0 || product.executable_site_elements.size > 0) && selected_tabs.include?("downloads")
      r << ProductTab.new("downloads_and_docs") if (product.softwares.size > 0 || product.product_documents.size > 0 || product.site_elements.size > 0) && selected_tabs.include?("downloads_and_docs")
      r << ProductTab.new("features") if product.features && selected_tabs.include?("features")
      r << ProductTab.new("specifications") if product.product_specifications.size > 0 && selected_tabs.include?("specifications")
      r << ProductTab.new("training_modules") if product.training_modules.size > 0 && selected_tabs.include?("training_modules")
      r << ProductTab.new("reviews") if (product.product_reviews.size > 0 || product.artists.size > 0) && selected_tabs.include?("reviews")
      r << ProductTab.new("artists") if product.artists.size > 0 && selected_tabs.include?("artists")
      r << ProductTab.new("tones") if product.tone_library_patches.size > 0 && selected_tabs.include?("tones")
      r << ProductTab.new("news_and_reviews") if product.news_and_reviews.size > 0 && selected_tabs.include?("news_and_reviews")
      r << ProductTab.new("gallery") if product.images_for("product_page").size > 0 && selected_tabs.include?("gallery")
      r << ProductTab.new("news") if product.current_news.size > 0 && selected_tabs.include?("news")
      r << ProductTab.new("support") if selected_tabs.include?("support")
    rescue
      # Fine then, no tabs for you
    end
    r
  end

  # Shows the HTML5 audio demos for this product
  def draw_audio_demos(product)
    ret = ""
    if product.audio_demos.size > 0
    # ret += '<div id="sm2-container"></div>'
    ret += "<h5>Audio Demos</h5>"
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
        buy_it_now_international(product, button, options)
		  elsif !product.direct_buy_link.blank?
        buy_it_now_direct_from_factory(product, button, options)
      elsif @online_retailer_link # http param[:bin] provided
        buy_it_now_direct_to_retailer(product, button)
		  else
        buy_it_now_usa(product, button, options)
		  end
		end    
  end

  def folder_for(product)
    (product.layout_class.to_s.match(/vocalist/)) ? product.layout_class : website.folder
  end

  def button_for(product, options)
    if product.direct_buy_link.blank?
      text = t("buy_it_now")
    elsif product.parent_products.size > 0 # as in e-pedals
      text = t("get_it")
    else
      text = t("add_to_cart")
    end
    text = text.downcase if options[:downcase]
    if options[:html_button] 
      text
    else
      loc = "#{I18n.locale}"
      folder = website.folder
      if product.direct_buy_link.blank?
        if File.exists?(Rails.root.join("app", "assets", "images", folder, loc, "#{options[:button_prefix]}buyitnow_button.png")) 
          image_tag("#{folder}/#{loc}/#{options[:button_prefix]}buyitnow_button.png", alt: text, mouseover: "#{folder}/#{loc}/#{options[:button_prefix]}buyitnow_button_hover.png")
        else
          text
        end
      elsif product.parent_products.size > 0 # as in e-pedals
        if File.exists?(Rails.root.join("app", "assets", "images", folder, loc, "#{options[:button_prefix]}getit_button.png")) 
          image_tag("#{folder}/#{loc}/#{options[:button_prefix]}getit_button.png", alt: text, mouseover: "#{folder}/#{loc}/#{options[:button_prefix]}getit_button_hover.png")
        else
          text
        end
      else
        if File.exists?(Rails.root.join("app", "assets", "images", folder, loc, "#{options[:button_prefix]}addtocart_button.png")) 
          image_tag("#{folder}/#{loc}/#{options[:button_prefix]}addtocart_button.png", alt: text, mouseover: "#{folder}/#{loc}/#{options[:button_prefix]}addtocart_button_hover.png")
        else
          text
        end
      end
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

  def buy_it_now_usa(product, button, options)
    button_class = button_class(button, options)
    if product.active_retailer_links.size > 0
      # tracker = (Rails.env.production?) ? "_gaq.push(['_trackEvent', 'BuyItNow', 'USA', '#{product.name}']);" : ""
      # link_to_function button, "#{tracker}popup('dealer_popup');"
      button_class += " buy_it_now_popup"

      html5_data = (options[:reveal_id]) ? {:'reveal-id' => options[:reveal_id]} : {windowname: 'dealer_popup'} # for old home-grown popup

      link_to(button, 
        buy_it_now_product_path(product), 
        class: button_class, 
        data: html5_data,
        onclick: raw("_gaq.push(['_trackEvent', 'BuyItNow', 'USA', '#{product.name}'])"))
    else
      link_to(button, 
        where_to_buy_path, 
        class: button_class,
        onclick: raw("_gaq.push(['_trackEvent', 'BuyItNow', 'Without online retailer links', '#{product.name}'])"))
    end
  end

  def buy_it_now_direct_to_retailer(product, button, options={})
    link_to(button, 
      @online_retailer_link.url, 
      class: button_class(button, options),
      target: "_blank", 
      onclick: raw("_gaq.push(['_trackEvent', 'BuyItNow-Dealer', '#{@online_retailer_link.online_retailer.name}', '#{product.name}'])"))
  end

  def buy_it_now_direct_from_factory(product, button, options={})
    link_to(button, 
      product.direct_buy_link, 
      class: button_class(button, options),
      target: "_blank", 
      onclick: raw("_gaq.push(['_trackEvent', 'AddToCart', 'USA (#{session['geo_country']})', '#{product.name}'])"))
  end

  def buy_it_now_international(product, button, options={})
    link_to(button, 
      international_distributors_path, 
      class: button_class(button, options),
      onclick: raw("_gaq.push(['_trackEvent', 'BuyItNow', 'non-USA (#{session['geo_country']})', '#{product.name}'])"))
  end

  # Used by the different buy it now methods to determine what kind of CSS class (if any)
  # to assign to the generated button
  #
  def button_class(button, options={})
    if button.to_s.match(/img/i)
      ""
    else
      options[:button_class] ? options[:button_class] : "medium button"
    end    
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
          tag(:br) +
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
          tag(:br) +
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
    (val.match(/^yes\s*?$/i)) ? image_tag("icons/check.png", alt: val) : val
  end
  
end
