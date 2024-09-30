module BannersHelper

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
    frames_css = ""
    options[:slides].each_with_index do |slide, i|
      frames += orbit_slideshow_frame(slide, i)
      if slide.is_a?(Banner)
        frames_css += banner_css(slide)
      end
    end

    content_tag(:style, raw(frames_css)) +
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
    send("slide_content_from_#{slide.class.to_s.downcase}", slide, position)
  end

  def slide_content_from_artist(artist, position)
    artist_brand = artist.artist_brands.where(brand_id: website.brand_id).first

    slide_content = link_to(artist) do
      image_tag(artist.artist_photo.url(:feature), alt: artist.name, loading: :eager) +
      content_tag(:div, class:"orbit-caption") do
        content_tag(:h2, artist.name) +
        content_tag(:p, artist_brand.intro.to_s.html_safe)
      end
    end

    content_tag(:li, slide_content)
  end

  # uses the new Banner model
  def slide_content_from_banner(banner, position, opts={})
    if opts[:banner_content]
      banner_content = opts[:banner_content]
    else
      banner_content = banner.content_for_current_locale
    end

    # mimic legacy slides for now
    if banner_content.link.to_s.match(/^((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?$/i)
      video_id = $5

      slide_content = link_to(play_video_url(video_id), target: "_blank", class: "start-video", data: { videoid: video_id } ) do
        image_tag(banner_content.slide.url, loading: :eager)
      end

    else
      link_options = {}
      this_locale = params[:locale] || I18n.locale.to_s || I18n.default_locale.to_s
      slide_link = (banner_content.link =~ /^\// || banner_content.link =~ /^http/i) ? banner_content.link : "/#{this_locale}/#{banner_content.link}"

      if slide_link.match(/^http/i) && !slide_link.match(/#{website.url}/i)
        link_options[:target] = "_blank"
      end

      if banner_content.content.present? || banner_content.title.present?
        htag = position == 0 ? :h1 : :h2
        bg_style = banner_content.slide.present? ?
          "background: { url('#{banner_content.slide.url}') }" :
          ""
        slide_innards = content_tag(:div, class: "banner banner_#{banner_content.locale}", id: "banner_#{banner.id}", style: bg_style) do
          content_tag(htag, banner_content.title) +
          content_tag(:div, banner_content.content.html_safe)
        end
      else
        slide_innards = image_tag(banner_content.slide.url,
          alt: banner_content.title || banner.name,
          fetchpriority: position == 0 ? "high" : "auto",
          loading: :eager)
      end

      slide_content = (banner_content.link.blank?) ?
        slide_innards :
        link_to(slide_innards, slide_link, link_options)
    end

    if p = website.value_for('countdown_overlay_position')
      if p == position && cd = website.value_for('countdown_container')
        slide_content += content_tag(:div, '', id: cd)
      end
    end

    content_tag(:li, slide_content)
  end

  def banner_css(banner)
    banner.content_for_current_locale.css.to_s
  end

  def slide_content_from_setting(setting, position)
    if setting.string_value.to_s.match(/^((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?$/i)
      video_id = $5

      slide_content = link_to(play_video_url(video_id), target: "_blank", class: "start-video", data: { videoid: video_id } ) do
        image_tag(setting.slide.url, loading: :eager)
      end

    else
      link_options = {}
      slide_link = (setting.string_value =~ /^\// || setting.string_value =~ /^http/i) ? setting.string_value : "/#{params[:locale]}/#{setting.string_value}"

      if slide_link.match(/^http/i) && !slide_link.match(/#{website.url}/i)
        link_options[:target] = "_blank"
      end

      slide_innards = image_tag(setting.slide.url,
        alt: setting.name,
        fetchpriority: position == 0 ? "high" : "auto",
        loading: :eager)

      if setting.text_value.present?
        slide_innards += content_tag(:div, class: "homepage-orbit-caption orbit-caption") do
          content_tag(:div, setting.text_value.html_safe, class: "caption-content")
        end
      end

      slide_content = (setting.string_value.blank?) ?
        slide_innards :
        link_to(slide_innards, slide_link, link_options)
    end

    if p = website.value_for('countdown_overlay_position')
      if p == position && cd = website.value_for('countdown_container')
        slide_content += content_tag(:div, '', id: cd)
      end
    end

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
        image_tag(slide.slide.url, loading: :eager) :
        link_to(image_tag(slide.slide.url, loading: :eager), slide_link, target: target)

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
            image_tag( anim.slide.url, loading: :eager)
          end
        elsif poster
          ret += content_tag(:div, class: "bg-gif") do
            image_tag( poster.slide.url, loading: :eager)
          end
        end

        if website.homepage_headline
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
        @leftover_slides = slides.reject{|f| /^#{fname}\./ =~ f.slide_file_name }

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

end
