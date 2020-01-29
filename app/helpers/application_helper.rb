# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include ActsAsTaggableOn::TagsHelper

  # Generates a link to the current page, with the given locale
  def switch_locale(new_locale)
    request.path.sub(/^\/[a-zA-Z\-]{2,8}/, "/#{new_locale}")
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

    ret =  tag(:meta, name: "apple-mobile-web-app-capable", content: "yes")
    ret += tag(:meta, name: "apple-mobile-web-app-status-bar-style", content: options[:status_bar_color])
    ret += tag(:meta, name: "apple-mobile-web-app-title", content: options[:title] )
    ret += tag(:meta, name: "format-detection", content: "telephone=no")

    # only one dimension needed, half-size (non-retina) sizes.
    sizes = [29, 40, 50, 57, 60, 72, 76].sort.reverse

    sizes.each do |size|
      # retina versions:
      if File.exists?(Rails.root.join("app", "assets", "images", options[:folder], "AppIcon#{size}x#{size}@2x.png"))
        ret += tag(:link, rel: "apple-touch-icon", sizes: "#{size*2}x#{size*2}", href: image_path("#{options[:folder]}/AppIcon#{size}x#{size}@2x.png") )
      end
    end
    sizes.each do |size|
      if File.exists?(Rails.root.join("app", "assets", "images", options[:folder], "AppIcon#{size}x#{size}.png"))
        ret += tag(:link, rel: "apple-touch-icon", sizes: "#{size}x#{size}", href: image_path("#{options[:folder]}/AppIcon#{size}x#{size}.png") )
      end
    end

    ret.html_safe
  end

  # Using zurb foundation to show the site's logo
  #
  def interchange_logo
    q = []
    q << "[#{image_path("#{website.folder}/logo.png")}, (default)]"
    q << "[#{image_path("#{website.folder}/logo.png")}, (large)]"
    q << "[#{image_path("#{website.folder}/logo.png")}, (medium)]"
    q << "[#{image_path("#{website.folder}/logo-sm.png")}, (only screen and (max-width: 720px))]"

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

  # Generates a slideshow using Zurb's Orbit. Accepts the same options as my
  # manually-built slideshow for backwards compatibility. Most options are
  # ignored.
  #
  def orbit_slideshow(options={})
    default_options = { duration: 7000, animation: 'slide', slide_number: false, navigation_arrows: true, slides: [] }
    options = default_options.merge options

    orbit_options = [
      "resume_on_mouseout:true",
      "timer_speed:#{options[:duration]}",
      "slide_number:#{options[:slide_number]}",
      "animation_speed:#{(options[:duration] / 12).to_i}",
      "animation:#{options[:transition]}",
      "navigation_arrows:#{options[:navigation_arrows]}"
    ]
    if options[:slides].length == 1 || options[:slides].length > 7
      orbit_options << "bullets:false"
    end
    if options[:slides].length == 1
      orbit_options << "timer:false"
    end

    frames = ""
    options[:slides].each_with_index do |slide, i|
      frames += orbit_slideshow_frame(slide, i)
    end
    content_tag(:div, class: "slideshow-wrapper") do
      content_tag(:div, "", class: "preloader") +
      content_tag(:ul,
        frames.html_safe,
        data: {
          orbit: true,
          options: orbit_options.join(";")
        }
      )
    end

  end

  # Used by the "orbit_slideshow" method to render a frame
  def orbit_slideshow_frame(slide, position=0)
    link_options = {}
    if slide.is_a?(Artist)
      artist = slide
      artist_brand = artist.artist_brands.where(brand_id: website.brand_id).first

      slide_content = link_to(artist) do
        image_tag(artist.artist_photo.url(:feature), alt: artist.name, lazy: false) +
        content_tag(:div, class:"orbit-caption") do
          content_tag(:h2, artist.name) +
          content_tag(:p, artist_brand.intro.to_s.html_safe)
        end
      end
    elsif slide.string_value.to_s.match(/^((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?$/i)
      video_id = $5

      slide_content = link_to(play_video_url(video_id), target: "_blank", class: "start-video", data: { videoid: video_id } ) do
        image_tag(slide.slide.url, lazy: false)
      end
    else
      slide_link = (slide.string_value =~ /^\// || slide.string_value =~ /^http/i) ? slide.string_value : "/#{params[:locale]}/#{slide.string_value}"

      if slide.string_value.to_s.match(/http/i)
        unless slide.string_value.to_s.match(/#{website.url}/i)
          link_options[:target] = "_blank"
        end
      end

      slide_innards = image_tag(slide.slide.url, lazy: false)
      if slide.text_value.present?
        slide_innards += content_tag(:div, class: "homepage-orbit-caption orbit-caption") do
          content_tag(:div, slide.text_value.html_safe, class: "caption-content")
        end
      end

      slide_content = (slide.string_value.blank?) ?
        slide_innards :
        link_to(slide_innards, slide_link, link_options)
    end

    # We may want to use the built-in captions
    # slide_content += content_tag(:div, "caption content", class: "orbit-caption")
    content_tag(:li, slide_content)
  end

  # Generates a slideshow based on a provided list of slides and
  # an optional duration. Each slide needs to respond to:
  #   .string_value  (with the URL to link to or blank for no link.
  #                   If the string_value starts with a slash (/),
  #                   then that is the absolute URL that will be used.
  #                   Otherwise, the locale from the current HTTP
  #                   request will be prepended to the URL.)
  #   .slide  (a Paperclip::Attachment)
  #
  # (Note: if only one slide is in the Array, then a single image
  # is rendered without the animation javascript.)
  #
  def slideshow(options={})
    default_options = { duration: 7000, slides: [], transition: "toggle" }
    options = default_options.merge(options)
    html = ''
    if options[:slides].size > 1
      html += slideshow_controls(options)
      options[:slides].each_with_index do |slide,i|
        html += slideshow_frame(slide, i)
      end
      raw(html + javascript_tag("start_slideshow(1, #{options[:slides].size}, #{options[:duration]}, '#{options[:transition]}');"))
    else
      raw(slideshow_frame(options[:slides].first))
    end
  end

  # Used by the "slideshow" method to render a frame
  def slideshow_frame(slide, position=0)
    hidden = (position == 0) ? "" : "display:none"
    slide_link = (slide.string_value =~ /^\// || slide.string_value =~ /^http/i) ? slide.string_value : "/#{params[:locale]}/#{slide.string_value}"

    target = (slide.text_value.to_s.match(/new.window|blank|new.tab/i)) ? "_blank" : ""
    slide_content = (slide.string_value.blank?) ?
        image_tag(slide.slide.url, lazy: false) :
        link_to(image_tag(slide.slide.url, lazy: false), slide_link, target: target)

    if p = website.value_for('countdown_overlay_position')
      if p == position && cd = website.value_for('countdown_container')
        slide_content += content_tag(:div, '', id: cd)
      end
    end

    content_tag(:div, slide_content, id: "slideshow_#{(position + 1)}", class: "slideshow_frame", style: hidden)

  end

  # Controls for the generated slideshow
  def slideshow_controls(options={})
    default_options = { duration: 6000, slides: [] }
    options = default_options.merge(options)
    if options[:slides].size > 1 && options[:slides].size < 7
      divs = ""
      (1..options[:slides].size).to_a.reverse.each do |i|
        divs += link_to_function(i,
                  "stop_slideshow(#{i}, #{options[:slides].size});",
                  id: "slideshow_control_#{i}",
                  class: (i==1) ? "current_button" : "")
      end
      content_tag(:div, id: "slideshow_controls") do
        raw(divs)
      end
    else
      ""
    end
  end

  # New homepage background video renderer. Still renders the slideshow on top of the
  # video if slides are provided in the admin.
  #
  def video_background_with_features(slides, options={})
    default_options = { hide_for_small: true, hide_arrow: false, pattern_overlay: true }
    options = default_options.merge options

    hide_for_small = (options[:hide_for_small]) ? "hide-for-small" : ""
    ret = ""

    if slides.size > 0
      if slides.pluck(:slide_file_name).find{|f| /^(.*)\.webm|mp4$/ =~ f}
        fname = $1

        video_sources = ""
        if webm = slides.find{|f| /webm/i =~ f.slide_content_type && /^#{fname}\./ =~ f.slide_file_name }
          video_sources += "<source src='#{ webm.slide.url }' type='#{ webm.slide_content_type }'/>"
        end

        if ogv = slides.find{|f| /ogv/i =~ f.slide_content_type && /^#{fname}\./ =~ f.slide_file_name }
          video_sources += "<source src='#{ ogv.slide.url }' type='video/ogg ogv' codecs='theora, vorbis'/>"
        end

        if mp4 = slides.find{|f| /mp4/i =~ f.slide_content_type && /^#{fname}\./ =~ f.slide_file_name }
          video_sources += "<source src='#{ mp4.slide.url }' type='#{ mp4.slide_content_type }'/>"
        end
        poster = slides.find{|f| /jpg|jpeg|png/i =~ f.slide_content_type && /^#{fname}\./ =~ f.slide_file_name }

        ret += content_tag(:video, video_sources.html_safe,
          poster: (poster) ? poster.slide.url : '',
          id: "video_background",
          preload: "auto",
          autoplay: "true",
          loop: "loop",
          muted: "true",
          volume: 0)

        if options[:pattern_overlay]
          ret += content_tag(:div, "", id: "video_pattern")
        end

        if anim = slides.find{|f| /gif/i =~ f.slide_content_type && /^#{fname}\./ =~ f.slide_file_name }
          ret += content_tag(:div, class: "bg-gif") do
            image_tag( anim.slide.url, lazy: false )
          end
        elsif poster
          ret += content_tag(:div, class: "bg-gif") do
            image_tag( poster.slide.url, lazy: false )
          end
        end

        static_slides = slides.reject{|f| /^#{fname}\./ =~ f.slide_file_name }
        if static_slides.length > 0
          ret += content_tag(:div, class: "row") do
            content_tag(:div, class: "large-12 #{ hide_for_small } columns") do
              orbit_slideshow(slides: static_slides, duration: 6000, navigation_arrows: false, transition: "fade")
            end
          end
        elsif website.homepage_headline
          if website.homepage_headline_product_id
            headline_slide = content_tag(:h1, website.homepage_headline)
            product = Product.find(website.homepage_headline_product_id)
            if product.name.match(/^\d*$/)
              headline_slide += content_tag(:p, "#{product.name} #{product.short_description_1}")
            else
              headline_slide += content_tag(:p, product.name)
            end
            headline_slide += link_to("Learn More", product, class: "secondary button")
            if product.in_production?
              headline_slide += buy_it_now_link(product, html_button: true)
            end
          elsif website.homepage_headline_product_family_id
            product_family = ProductFamily.find(website.homepage_headline_product_family_id)
            headline_slide = content_tag(:h1, product_family.name.titleize)
            headline_slide += content_tag(:p, website.homepage_headline)
            headline_slide += link_to("Learn More", product_family, class: "button")
          else
            headline_slide = content_tag(:h1, website.homepage_headline)
          end
          headline_class = website.homepage_headline_overlay_class || "large-6 small-12 columns"
          ret += content_tag(:div, class: 'row headline_slide') do
            content_tag(:div, headline_slide, class: headline_class )
          end
        else
          ret += content_tag(:div, class: "container", id: "feature_spacer") do
            if options[:tagline]
              content_tag(:h1, website.tagline, id: "tagline")
            end
          end
        end

        ret = content_tag(:div, ret.html_safe, id: "video-container", class: hide_for_small)
        ret += content_tag(:div, "", class: "bouncing-arrow") unless options[:hide_arrow]

      else

        ret += content_tag(:div, class: "row") do
          content_tag(:div, class: "large-12 #{ hide_for_small } columns") do
            orbit_slideshow(slides: slides, duration: 6000, navigation_arrows: false, transition: "fade")
          end
        end

      end
    end

    raw(ret)
  end

  # Generates social media links. Accepts a list of different
  # types of links. Looks for the related Setting and matching
  # image and puts them together.
  #
  def social_media_links(*networks)
    options = networks.last.is_a?(Hash) ? networks.pop : { size: "21x20"}
    html = ''
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
          v = (v =~ /^http/i) ? v : "http://www.#{n}.com/#{v}"
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
          html += link_to(presentation, v, target: "_blank")
        end
      end
    end
    raw(html)
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
    image_tag img, style: "vertical-align: middle"
	end

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
    image_tag img, style: "vertical-align: middle"
  end  #  def file_type_icon(item)

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
    if File.exists?(Rails.root.join("app", "views", "#{website.folder}/#{name.gsub(/\/(?!.*\/)/, "/_")}.html.erb"))
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
      {name: "AKG",    web: "http://www.akg.com"},
      {name: "AMX",    web: "http://www.amx.com"},
      {name: "BSS",    web: "http://www.bssaudio.com"},
      {name: "Crown",  web: "http://www.crownaudio.com"},
      {name: "dbx",    web: "http://www.dbxpro.com"},
      {name: "DigiTech",   web: "http://www.digitech.com"},
      {name: "JBL",    web: "http://www.jblpro.com" },
      {name: "Lexicon",    web: "http://www.lexiconpro.com"},
      {name: "Martin",  web: "http://www.martin.com"},
      {name: "Soundcraft", web: "http://www.soundcraft.com"},
      {name: "Studer", web: "http://www.studer.ch"},
      #{name: "HiQnet", web: "http://hiqnet.harmanpro.com"}
    ]

    pro_brands.each do |b|
      unless website.brand.name.match(/#{b[:name]}/i) || options[:exclude].match(/#{b[:name]}/i)
        links << link_to(b[:web], target: "_blank") do
          image_tag("pro_brands/#{b[:name].downcase}.png", alt: b[:name], lazy: false)
        end
      end
    end

    harman_link = link_to(ENV['PRO_SITE_URL'], target: "_blank") do
      image_tag("pro_brands/harman.png", alt: "Harman Professional", class:"hlogo", lazy: false)
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
    session['geo_country'].gsub(/[^a-zA-Z]/, '').slice(0..1).downcase
  end

  def country_is_usa
    (session['geo_usa'] == true) || (clean_country_code == 'us')
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
