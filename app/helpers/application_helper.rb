# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include ActsAsTaggableOn::TagsHelper

  # Generates a link to the current page, with the given locale
  # If we can determine the current page is not relevant to the new locale,
  # then try to link to a similar relevant resource. Otherwise,link to the
  # homepage for the new locale instead
  def switch_locale(new_locale)
    link_to_homepage = false

    begin
      if instance_variable = instance_variable_get("@#{controller_name.singularize}")
        if instance_variable.respond_to?(:locales)
          unless instance_variable.locales(website).include?(new_locale)
            if instance_variable.respond_to?(:geo_alternative) && geo_alternative = instance_variable.geo_alternative(website, new_locale)
              return url_for(request.params.merge(id: geo_alternative.to_param, locale: new_locale))
            end
            link_to_homepage = true
          end
        end
      end
    rescue
      # avoid errors on top nav
    end

    link_to_homepage ?
      "/#{new_locale}" :
      full_url_for(request.params.merge(locale: new_locale))
  end

  # Determines if we should hide the given locale from a user
  def exclude_locale_from_options?(locale)
    if !(session['geo_usa']) && locale.to_s.match?(/\-US/i)
      return true # Hide en-US if we're not in the US
    elsif !!(session['geo_usa'])  && ["en", "en-asia"].include?(locale.to_s)
      return true # Hide en, en-asia if we are in the US
    end
    return false
  end

  # Apple iOS icons for a given Website.brand
  #
  def app_meta_tags(options={})
    if website
      default_options = { folder: website.folder, title: (website.brand.present?) ? website.brand.name : website.site_name, status_bar_color: "black" }
    else
      default_options = { folder: "", title: "", status_bar_color: "black" }
    end
    options = default_options.merge options

    ret =  tag(:meta, name: "mobile-web-app-capable", content: "yes")
    ret += tag(:meta, name: "apple-mobile-web-app-status-bar-style", content: options[:status_bar_color])
    ret += tag(:meta, name: "apple-mobile-web-app-title", content: options[:title] )
    ret += tag(:meta, name: "format-detection", content: "telephone=no")

    # only one dimension needed, half-size (non-retina) sizes.
    sizes = [29, 40, 50, 57, 60, 72, 76].sort.reverse

    sizes.each do |size|
      # retina versions:
      if File.exist?(Rails.root.join("app", "assets", "images", options[:folder], "AppIcon#{size}x#{size}@2x.png"))
        ret += tag(:link, rel: "apple-touch-icon", sizes: "#{size*2}x#{size*2}", href: image_path("#{options[:folder]}/AppIcon#{size}x#{size}@2x.png") )
      end
    end
    sizes.each do |size|
      if File.exist?(Rails.root.join("app", "assets", "images", options[:folder], "AppIcon#{size}x#{size}.png"))
        ret += tag(:link, rel: "apple-touch-icon", sizes: "#{size}x#{size}", href: image_path("#{options[:folder]}/AppIcon#{size}x#{size}.png") )
      end
    end

    ret.html_safe
  end

  # Using zurb foundation to show the site's logo
  #
  def interchange_logo
    q = []
    q << "[#{image_path("#{website.folder}/logo.svg")}, (default)]"
    q << "[#{image_path("#{website.folder}/logo.svg")}, (large)]"
    q << "[#{image_path("#{website.folder}/logo.svg")}, (medium)]"
    q << "[#{image_path("#{website.folder}/logo.white.svg")}, (only screen and (max-width: 720px))]"

    image_tag('', #"#{website.folder}/logo.png",
      class: "no-resize no-resize-for-small",
      alt: Setting.site_name(website),
      data: { interchange: q.join(", ") })
  end

  def extra_top_nav_links(options={})
    begin
      ret = ""
      if !!(website.extra_top_nav_links)
        website.extra_top_nav_links.split(/\r\n|\r|\n|\|/).each do |t|
          t.match(/^([^\[\]]*)\[+([^\[\]]*)\]+/)
          name = $1
          href = $2
          if !!name && !!href
            if options[:divider]
              ret += content_tag(:li, "", class: "divider")
            end
            unless href.match(/^(http|\/)/i)
              href = "/#{I18n.locale}/#{href}"
            end
            if href.match(/^http/i)
              ret += content_tag(:li, link_to(name, href, target: "_blank", class: "hide-for-small hide-for-medium"))
            else
              ret += content_tag(:li, link_to(name, href))
            end
          end
        end
      end
    rescue
      # avoid top nav errors
    end
    ret.html_safe
  end

  # Generates social media links. Accepts a list of different
  # types of links. Looks for the related Setting and matching
  # image and puts them together.
  #
  def social_media_links(*networks)
    options = networks.last.is_a?(Hash) ? networks.pop : { size: "21x20"}
    if options[:style] && options[:style] == "link-list"
      html = []
    else
      html = ''
    end
    networks.to_a.each do |n|
      if n == 'rss'
        if options[:style] && File.exist?(Rails.root.join("app/assets/images/icons/#{options[:style]}/#{options[:size]}", "#{n}.png"))
          q = []
          q << "[#{image_path("icons/#{options[:style]}/#{options[:size]}/#{n}.png")},  (default)]"
          q << "[#{image_path("icons/#{options[:style]}/#{options[:size]}/#{n}.png")}, (only screen and (min-width: 1350px))]"
          q << "[#{image_path("icons/#{options[:style]}/64x64/#{n}.png")},              (only screen and (min-width: 1024px) and (max-width: 1349px))]"
          q << "[#{image_path("icons/#{options[:style]}/48x48/#{n}.png")},             (only screen and (max-width: 768px))]"

          image_tag("#{website.folder}/logo.png",
            class: "no-resize no-resize-for-small",
            alt: Setting.site_name(website),
            data: { interchange: q.join(", ") })
          html += link_to(image_tag("icons/#{options[:style]}/#{options[:size]}/#{n}.png",
              style: "vertical-align: middle;",
              size: options[:size],
              data: { interchange: q.join(", ") }),
            rss_url(format: "xml"), target: "_blank")
        else
          html += link_to(image_tag("icons/#{n}.png", style: "vertical-align: middle;", size: options[:size]), rss_url(format: "xml"), target: "_blank")
        end

      elsif v = website.value_for(n)
        unless v.blank?
          v = (v =~ /^https/i) ? v : "https://www.#{n}.com/#{v}"
          presentation = n
          if options[:style] == "font-awesome"
            presentation = fa_icon("#{n} 2x", :"aria-label" => n)
          elsif options[:style] && File.exist?(Rails.root.join("app/assets/images/icons/#{options[:style]}/#{options[:size]}", "#{n}.png"))
            presentation = image_tag("icons/#{options[:style]}/#{options[:size]}/#{n}.png",
                                     style: "vertical-align: middle",
                                     size: options[:size],
                                     alt: n,
                                     :"aria-label" => n)
          elsif options[:gray]
            presentation = image_tag("social/social-gray-#{n.downcase}.png",
                                     class: "no-resize",
                                     alt: n,
                                     :"aria-label" => n)
          elsif File.exist?(Rails.root.join("app/assets/images/icons", "#{n}.png"))
            presentation = image_tag("icons/#{n}.png",
                                     style: "vertical-align: middle",
                                     size: options[:size],
                                     alt: n,
                                     :"aria-label" => n)
          end

          if options[:style] == "link-list"
            html << v
          else
            html += link_to(presentation, v, target: "_blank", :"aria-label" => n)
          end
        end
      end
    end
    if options[:style] && options[:style] == "link-list"
      html
    else
      raw(html)
    end
  end

  # Remove HTML from a string (helpful for truncated intros of
  # pre-formatted HTML)
  def strip_html(string="")
    begin
      string = strip_tags(string)
      string = string.gsub(/<\/?[^>]*>/,  "")
      string = string.gsub(/\&+\w*\;/, " ") # replace &nbsp; with a space
      string.html_safe
    rescue
      raw("<!-- error stripping html from: #{string} -->")
    end
  end

  # Capitalize the first letter of each word in a phrase
  def ucfirst(my_string)
    raw(my_string.split(" ").each{|word| word.capitalize!}.join(" "))
  end

  # Figure out what the link to a give Page should be
  def page_link(page)
    if page.is_a?(Page)
      (page.custom_route.blank?) ?
        page_url(page, locale: I18n.locale) :
        custom_page_url(page) #custom_route_url(page.custom_route)
    else
      (Rails.env.production? || Rails.env.staging?) ?
        "#{request.protocol}#{request.host}#{url_for(page)}" :
        "#{request.protocol}#{request.host_with_port}#{url_for(page)}"
    end
  end

  def custom_page_url(page)
    locale_path = I18n.locale.to_s.match(/en/i) ? "" : "#{I18n.locale.to_s}/"
    (Rails.env.production? || Rails.env.staging?) ?
      "#{request.protocol}#{request.host}/#{locale_path}#{page.custom_route}" :
      "#{request.protocol}#{request.host_with_port}/#{locale_path}#{page.custom_route}"
  end

  # Platform icon. Make sure there are icons for all the different platforms and sizes
  # in the public/images folder
  def platform_icon(software, size=17)
    img = case software.platform.to_s
      when /windows/i
        "icons/windows_#{size}.png"
      when /mac/i
        "icons/mac_#{size}.png"
      when /linux/i
        "icons/tux_#{size}.png"
      when /ios/i
        "icons/iOS_#{size}.png"
      when /android/i
        "icons/android_#{size}.png"
      else
        "icons/download_#{size}.png"
    end
    image_tag img, style: "vertical-align: middle", alt: "platform icon"
	end

  def lazy_load_image?(product)
    return false if product.photo.nil?
    lazy_load = case File.extname(product.photo.product_attachment_file_name)
    when /.png/
      false
    when /.jpg/
      true
    when /.jpeg/
      true
    when /.gif/
      false
    else
      false
    end
  end  #  def lazy_load_image?(product)

  def file_type_icon(item, size=17)
    img = case true
          when
            # item.is_a?(SiteElement)
            (item.respond_to?(:executable_content_type) && !!item.executable_content_type.to_s.match(/pdf/i)) ||
            (item.respond_to?(:resource_content_type) && !!item.resource_content_type.to_s.match(/pdf/i)) ||
            (item.respond_to?(:resource_file_name) && !!item.resource_file_name.to_s.match(/pdf$/i)) ||

            # item.is_a?(ProductDocument)
            (item.respond_to?(:document_content_type) && !!item.document_content_type.to_s.match(/pdf/i)) ||
            (item.respond_to?(:document_file_name) && !!item.document_file_name.to_s.match(/pdf$/i)) ||

            # item.is_a?(SoftwareAttachment)
            (item.respond_to?(:software_attachment_content_type) && !!item.software_attachment_content_type.to_s.match(/pdf/i))

            "icons/pdf_#{size}.png"
          else
            "icons/download_#{size}.png"
          end
    image_tag img, style: "vertical-align: middle", alt: "file type icon"
  end  #  def file_type_icon(item)

  def product_photo_is_png?(product)
    product.photo.present? ? (product.photo.product_attachment_file_name.to_s.match?(/\.png$/i)) : false
  end

  def seconds_to_HMS(time)
    time = time.to_i
    [time/3600, time/60 % 60, time % 60].map{|t| t.to_s.rjust(2,'0')}.join(':')
  end

  def seconds_to_MS(time)
    time = time.to_i
    [time/60 % 60, time % 60].map{|t| t.to_s.rjust(2,'0')}.join(':')
  end

  # Generates links to related products. Pass in any object which has a #products
  # method which returns a collection of Products
  def links_to_related_products(parent)
    begin
      links = []
      parent.products.each do |product|
        links << link_to(product.name, product)
      end
      raw(links.join(", "))
    rescue
      ""
    end
  end

  def image_url(source)
    abs_path = image_path(source)
    unless abs_path =~ /^http/
      abs_path = "#{request.protocol}#{request.host_with_port}#{abs_path}"
    end
    abs_path
  end

  # Replacement for render :partial, this version considers the
  # site's brand and checks for a custom partial.
  def render_partial(name, options={})
    name = name.to_s
    if File.exist?(Rails.root.join("app", "views", "#{website.folder}/#{name.gsub(/\/(?!.*\/)/, "/_")}.html.erb"))
      name = "#{website.folder}/#{name}"
    end
    eval("render '#{name}', options")
  end

  def hpro_footer(options={})
    default_options = {exclude: ""}
    options = default_options.merge options

    if website.footer_exclusion
      options[:exclude] = website.footer_exclusion
    end

    links = []
    pro_brands = [
      {name: "AKG",    web: "https://www.akg.com"},
      {name: "AMX",    web: "https://www.amx.com"},
      {name: "BSS",    web: "https://www.bssaudio.com"},
      {name: "Crown",  web: "https://www.crownaudio.com"},
      {name: "dbx",    web: "https://www.dbxpro.com"},
      {name: "JBL",    web: "https://www.jblpro.com" },
      {name: "Lexicon",    web: "https://www.lexiconpro.com"},
      {name: "Martin",  web: "https://www.martin.com"},
      {name: "Soundcraft", web: "https://www.soundcraft.com"}
    ]

    pro_brands.each do |b|
      unless website.brand.name.match(/#{b[:name]}/i) || options[:exclude].match(/#{b[:name]}/i)
        links << link_to(b[:web], target: "_blank") do
          image_tag("pro_brands/#{b[:name].downcase}.svg", alt: b[:name], id:"footer_logo_#{b[:name].downcase}", class:"footer_brand_logos", lazy: false)
        end
      end
    end

    harman_link = link_to(ENV['PRO_SITE_URL'], target: "_blank") do
      image_tag("pro_brands/harman.svg", alt: "Harman Professional", class:"hlogo", lazy: false)
    end

    content_tag :div, id: "harmanpro_bar" do
      content_tag(:div, class: "row") do
        concat(content_tag(:div, harman_link, class: "large-3 columns hide-for-medium-down text-center"))
        concat(content_tag(:div, class: "large-9 small-12 columns") do
          content_tag(:ul, class: "large-block-grid-#{links.length} small-block-grid-5") do
            raw(links.map{|link| content_tag(:li, link)}.join)
          end
        end)
      end
    end
  end

  def country_name(country_code)
    country_names = CountryList.countries.select {|country| country[:alpha2] == country_code.upcase}
    country_names.present? ? country_names.first[:harman_name] : ""
  end

  def country_code
    if session['geo_country']
      session['geo_country'].gsub(/[^a-zA-Z]/, '').slice(0..1).downcase
    else
      "US"
    end
  end

  def country_is_usa
    (session['geo_usa'] == true) || (clean_country_code == 'us')
  end

  def country_is_usa_or_canada
    country_is_usa || (clean_country_code == 'ca')
  end

  def user_has_usa_state?
    !session['geo_usa_state'].nil?
  end

  def user_usa_state
    user_has_usa_state? ? session['geo_usa_state'] : ''
  end

  def user_usa_state_code
    user_has_usa_state? ? us_states.key(user_usa_state) : ''
  end

end
