module MainHelper

  # Borrowed from rails 3.2 source so I can avoid rewriting all of
  # the link_to_function calls in my code
  def link_to_function(name, function, html_options={})
    onclick = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function}; return false;"
    href = html_options[:href] || '#'

    content_tag(:a, name, html_options.merge(:href => href, :onclick => onclick))
  end

  def feature_button(feature, opts={})
    if feature.name.present?
      panel = image_tag(feature.slide.url, alt: feature.name, lazy: false)
    else
      panel = image_tag(feature.slide.url, lazy: false)
    end

    if opts[:carousel] == true
      panel += content_tag(:h6, feature.name)
      panel += content_tag(:p, feature.text_value, style: 'color: black')
      panel += content_tag(:p, 'LEARN MORE')
    end

    if feature.string_value.blank?
      panel
    else
      if feature.string_value =~ /^https?\:/i
        link_to(panel, feature.string_value, target: "_blank")
      elsif feature.string_value =~ /^\//
        link_to(panel, feature.string_value)
      else
        link_to(panel, "/#{params[:locale]}/#{feature.string_value}")
      end
    end
  end

  # Note to self: if we want to display a specific playlist only, do this:
  #
  #   y = YouTubeIt::Client.new
  #   playlist = y.playlists_for('DigiTechFX').first
  #   # then do something with playlist.videos...
  #
  # Or, if I already know the playlist_id:
  #
  #   y.playlist('864F02DBB06D4EE1').videos.each do |video|
  #     link_to video.title, video.link
  #   end
  #
  def youtube_feed(youtube_user, style="table", options={})
    return horizontal_youtube_feed(youtube_user, options) if style == "horizontal"

    limit = (style == "table") ? 4 : 3
    if youtube_user
      begin
	      ret = (style == "table") ? '<table class="news_list" style="margin-left: 20px">' : '<div id="video_list">'
        if website.youtube_playlist_for_homepage.present?
          playlist = website.youtube_playlist_for_homepage
        else
          playlist = Youtube.get_default_playlist_id(youtube_user)
        end
        Youtube.get_video_list_data(playlist, limit: limit)["items"].each do |v|
          video = v["snippet"]
          thumbnail = video["thumbnails"]["default"] #.find(height: 90).first[1]
          link = play_video_url(video["resourceId"]["videoId"])
          if style == "table"
            ret += "<tr>"
            ret +=   "<td><div style='margin-left: auto; margin-right: auto; position: relative; width:120px; height:90px'>"
            ret +=     "<img src='#{thumbnail["url"]}' width='120' height='90'/>"
            #ret +=     "<div style='position:absolute; top: 30px; left: 45px; z-index: 1'>"
            #ret +=        link_to(image_tag("play.png", alt: video["title"]), link)
            #ret +=     "</div>"
            ret +=   "</div></td>"
            ret +=   "<td class='preview'><p><b>"
            ret +=   link_to(video["title"], link)
            ret +=   "</b></p></td>"
            ret += "</tr>"
          else
            ret += "<div class='video_thumbnail'>"
            ret +=     link_to("<img src='#{thumbnail["url"]}' width='180' height='135'/>".html_safe, link,
                               data: { videoid: video["resourceId"]["videoId"] }, class: 'start-video')
            ret +=     content_tag(:div, truncate(video["title"]))
            #ret +=     content_tag(:div, link_to(image_tag("play.png", alt: video["title"]), link), class: 'play_button')
            ret += "</div>"
          end
	      end
	      ret += (style == "table") ? "</table>" : "</div>"
        raw(ret)
      rescue
        if !youtube_user.blank?
          link_to("YouTube Channel", "https://www.youtube.com/user/#{youtube_user}", target: "_blank")
        end
      end
    end
  end

  def horizontal_youtube_feed(youtube_user, options)
    if youtube_user
      begin
        vids = []
        if website.youtube_playlist_for_homepage.present?
          playlist = website.youtube_playlist_for_homepage
        else
          playlist = Youtube.get_default_playlist_id(youtube_user)
        end
        Youtube.get_video_list_data(playlist, options)["items"].each do |v|
          video = v["snippet"]
          thumbnail = video["thumbnails"]["default"] #.find(height: 90).first[1]
          link = play_video_url(video["resourceId"]["videoId"])
          vids << content_tag(:li, class: 'video_thumbnail') do
            #content_tag(:div, link_to(image_tag("play.png", alt: video["title"]), link, target: "_blank"), class: 'play_button') +
            link_to(image_tag(thumbnail["url"], width: 180, height: 135), link, target: "_blank",
                               data: { videoid: video["resourceId"]["videoId"] }, class: 'start-video') +
            content_tag(:p, video["title"], class: 'video_title')
          end
        end
        content_tag(:ul, raw(vids.join), id: 'video_list', class: "large-block-grid-4 medium-block-grid-4 small-block-grid-2")
      rescue
        if !youtube_user.blank?
          link_to("YouTube Channel", "https://www.youtube.com/user/#{youtube_user}", target: "_blank")
        end
      end
    end
  end

  def preload_background_images
    begin
      content = ""
      website.products.where("background_image_file_name IS NOT NULL").each do |product|
  		  content += image_tag(product.background_image.url("original", false), height: 0, width: 0, lazy: false)
  	  end
  	  content.html_safe
	  rescue
	    ""
    end
  end

  # Developed for the 2014 dbx site
  def featured_product_icons(product, num)
    dir = Rails.root.join('app', 'assets', 'images', website.folder, "#{product.friendly_id}_icons")

    if Dir.exists?(dir)
      icons = []
      Dir.foreach(dir) do |icon|
        next if icon =~ /^\./
        icons << image_tag("#{website.folder}/#{product.friendly_id}_icons/#{icon}")
      end

      content_tag(:div, icons.shuffle.join.html_safe, id: "featured_icons_#{num}", class: "hidden_icons hide-for-small")
    end
  end

  def product_family_nav_links(product_family, options={})
    if product_family.locales(website).include?(I18n.locale.to_s)
      default_options = {depth: 99}
      options = default_options.merge options

      child_links = []
      product_links = []

      relevant_children = product_family.children_with_current_products(website, locale: I18n.locale)
      #options[:depth] += 1 if relevant_children.size > 0

      if options[:depth] > 1
        child_links = relevant_children.map do |sub_family|
          product_family_nav_links(sub_family, options)
        end
        options[:depth] -= 1

        if options[:depth] > 1
          product_links = product_family.current_products.map do |product|
            content_tag(:li, link_to(translate_content(product, :name), product))
          end
        end
      end

      # An ugly exception to show JBL Commercial under the Commercial
      # category for Crown.
      if product_family.name.to_s.match(/commercial/i) && product_family.brand.name.to_s.match(/crown/i)
        child_links << content_tag(:li, link_to("JBL Commercial", "//www.jblcommercialproducts.com/", target: "_blank"))
      end

      dropdown_class = (child_links + product_links).length > 0 ? "has-dropdown" : ""

      content_tag(:li, class: dropdown_class) do
        link_to(translate_content(product_family, :name), product_family) +
        content_tag(:ul, child_links.join.html_safe + product_links.join.html_safe, class: "dropdown")
      end.html_safe
    end
  end

  def market_segment_nav_links(market_segment, options={})
    default_options = {depth: 99}
    options = default_options.merge options

    child_links = []

    relevant_children = market_segment.children
    options[:depth] += 1 if relevant_children.length > 0

    if options[:depth] > 1
      child_links = relevant_children.map do |sub_family|
        market_segment_nav_links(sub_family, options)
      end
      options[:depth] -= 1
    end

    dropdown_class = child_links.length > 0 ? "has-dropdown" : ""

    content_tag(:li, class: dropdown_class) do
      link_to(translate_content(market_segment, :name), market_segment) +
      content_tag(:ul, child_links.join.html_safe, class: "dropdown")
    end.html_safe
  end

  def flag_for(item)
    if item.respond_to?(:language) && item.language.present?
      image_tag("icons/flags/#{item.language.to_s.downcase}.png", alt: item.language, lazy: false)
    end
  end
end

