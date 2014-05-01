# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Generates a link to the current page, with the given locale
  def switch_locale(new_locale)
    request.path.sub(/^\/[a-zA-Z\-]{2,5}/, "/#{new_locale}")    
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

    image_tag("#{website.folder}/logo.png", 
      class: "no-resize no-resize-for-small",
      alt: Setting.site_name(website),
      data: { interchange: q.join(", ") })
  end

  def cached_meta_tags
    @page_description ||= website.value_for('default_meta_tag_description') 
    @page_keywords ||= website.value_for("default_meta_tag_keywords") 
    begin
      display_meta_tags site: Setting.site_name(website)
    rescue
    end
  end

  # Generates a slideshow using Zurb's Orbit. Accepts the same options as my
  # manually-built slideshow for backwards compatibility. Most options are
  # ignored.
  #
  def orbit_slideshow(options={})
    default_options = { duration: 7000, slide_number: false, navigation_arrows: true, slides: [] }
    options = default_options.merge options

    if options[:slides].length == 1
      raw(orbit_slideshow_frame(options[:slides].first))
    else
      orbit_options = [
        "resume_on_mouseout:true",
        "timer_speed:#{options[:duration]}",
        "slide_number:#{options[:slide_number]}",
        "animation_speed:#{(options[:duration] / 12).to_i}",
        "navigation_arrows:#{options[:navigation_arrows]}"
      ]

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
  end

  # Used by the "orbit_slideshow" method to render a frame
  def orbit_slideshow_frame(slide, position=0)
    slide_link = (slide.string_value =~ /^\// || slide.string_value =~ /^http/i) ? slide.string_value : "/#{params[:locale]}/#{slide.string_value}"

    slide_content = (slide.string_value.blank?) ? 
        image_tag(slide.slide.url) : 
        link_to(image_tag(slide.slide.url), slide_link)

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

    slide_content = (slide.string_value.blank?) ? 
        image_tag(slide.slide.url) : 
        link_to(image_tag(slide.slide.url), slide_link)

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
    default_options = { hide_for_small: true, hide_arrow: false }
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

        if anim = slides.find{|f| /gif/i =~ f.slide_content_type && /^#{fname}\./ =~ f.slide_file_name }
          ret += content_tag(:div, class: "bg-gif") do 
            image_tag( anim.slide.url )
          end
        end

        static_slides = slides.reject{|f| /^#{fname}\./ =~ f.slide_file_name } 
        if static_slides.length > 0
          ret += content_tag(:div, class: "row") do
            content_tag(:div, class: "large-12 #{ hide_for_small } columns") do
              orbit_slideshow(slides: static_slides, duration: 6000, navigation_arrows: false, transition: "fade")
            end
          end
        else
          ret += content_tag(:div, class: "container", id: "feature_spacer") do 
            if options[:tagline]
              content_tag(:h1, website.tagline, id: "tagline")
            end
          end
        end

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
    html = ''
    networks.to_a.each do |n|
      if n == 'rss'
        html += link_to(image_tag("icons/#{n}.png", style: "vertical-align: middle;", size: "21x20"), rss_url(format: "xml"), target: "_blank")
      elsif v = website.value_for(n)
        v = (v =~ /^http/i) ? v : "http://www.#{n}.com/#{v}"
        if File.exist?(Rails.root.join("app/assets/images/icons", "#{n}.png"))
          html += link_to(image_tag("icons/#{n}.png", style: "vertical-align: middle", size: "21x20"), v, target: "_blank")
        else
          html += link_to(n, v, target: "_blank")
        end
      end
    end
    raw(html)
  end  
  
  # Remove HTML from a string (helpful for truncated intros of 
  # pre-formatted HTML)
  def strip_html(string="")
    begin
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
      (page.custom_route.blank?) ? page_url(page, locale: I18n.locale) : custom_route_url(page.custom_route, locale: I18n.locale)
    else
      (Rails.env.production? || Rails.env.staging?) ? "#{request.protocol}#{request.host}#{url_for(page)}" : "#{request.protocol}#{request.host_with_port}#{url_for(page)}"
    end
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
        "icons/none_#{size}.png"
    end
    image_tag img, style: "vertical-align: middle"
	end
	
	# Links to software packages for a product that fit a given category
	def software_category_links(product, category="other")
	  links = []
	  product.softwares.each do |software|
	    if (software.category == category || (software.category.blank? && category=="other")) && software.active?
	      icon = platform_icon(software)
	      link = link_to(software.name, software_path(software, locale: I18n.locale))
        platform_and_version = software.version
        platform_and_version += " (#{software.platform})" if software.platform.present?
	      links << "#{icon} #{link} #{platform_and_version}"
	    end
	  end
	  raw(links.join("<br/>"))
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
	
	# Tries to find a ContentTranslation for the provided field for current locale. Falls
	# back to language only or default (english)
	def translate_content(object, method)
	  c = object[method] # (default)
    return c if I18n.locale == I18n.default_locale || I18n.locale == 'en'
	  parent_locale = (I18n.locale.to_s.match(/^(.*)-/)) ? $1 : false
	  translations = ContentTranslation.where(content_type: object.class.to_s, content_id: object.id, content_method: method.to_s)
	  if t = translations.where(locale: I18n.locale).first
	    c = t.content
    elsif parent_locale
      if t = translations.where(locale: parent_locale).first
        c = t.content
      elsif t = translations.where(["locale LIKE ?", "'#{parent_locale}%%'"]).first
        c = t.content
      end
    elsif auto = auto_translate(object, method)
      c = auto
    end
    c.to_s.html_safe
	end

  # Bing translate, store results, rescue in case of error
  def auto_translate(object, method)
    if HarmanSignalProcessingWebsite::Application.config.auto_translate
      begin
        if translated = ContentTranslation.create_or_update_with_auto_translate(object, method, I18n.locale)
          translated.content
        end
      rescue
        object[method]
      end
    else
      object[method]
    end
  end
	
	def image_url(source)
    abs_path = image_path(source)
    unless abs_path =~ /^http/
      abs_path = "#{request.protocol}#{request.host_with_port}#{abs_path}"
    end
    abs_path
  end
  
  # Render an unordered list of the top top nav
  def supernav
    families = ProductFamily.parents_for_supernav(website, I18n.locale)
    ret = "<ul>"
    families.each do |product_family|
      lastchild = (product_family == families.last) ? "last-child" : ""
      ret += content_tag(:li, link_to(translate_content(product_family, :name), product_family), class: lastchild)
    end
    ret += "</ul>"
    ret.html_safe
  end
  
  # Replacement for render :partial, this version considers the
  # site's brand and checks for a custom partial.
  def render_partial(name, options={})
    if File.exists?(Rails.root.join("app", "views", "#{website.folder}/#{name.gsub(/\/(?!.*\/)/, "/_")}.html.erb"))
      name = "#{website.folder}/#{name}"
    end
    eval("render '#{name}', options")
  end

  def hpro_footer(options={})
    default_options = {exclude: "", include_hpro: false}
    options = default_options.merge options

    links = []
    links << link_to(image_tag("pro_brands/harmanpro.png", alt: "HarmanPro", class: "no-resize"), "http://www.harmanpro.com", target: "_blank")

    pro_brands = [
      {name: "AKG",    web: "http://www.akg.com"},
      {name: "BSS",    web: "http://www.bssaudio.com"},
      {name: "Crown",  web: "http://www.crownaudio.com"}, 
      {name: "dbx",    web: "http://www.dbxpro.com"}, 
      {name: "DigiTech",   web: "http://www.digitech.com"}, 
#      {name: "IDX",    web: "http://idx.harman.com"},
      {name: "JBL",    web: "http://www.jblpro.com" }, 
      {name: "Lexicon",    web: "http://www.lexiconpro.com"}, 
      {name: "Martin",  web: "http://www.martin.com"},
      {name: "Soundcraft", web: "http://www.soundcraft.com"}, 
      {name: "Studer", web: "http://www.studer.ch"}, 
      {name: "HiQnet", web: "http://hiqnet.harmanpro.com"}
    ]
    pro_brands.each do |b|
      unless website.brand.name.match(/#{b[:name]}/i) || options[:exclude].match(/#{b[:name]}/i)
        links << link_to(image_tag("pro_brands/#{b[:name].downcase}.png", alt: b[:name], class: "no-resize"), b[:web], target: "_blank") 
      end
    end
    content_tag :div, raw(links.join), id: "harmanpro_bar"
  end
  	
end
