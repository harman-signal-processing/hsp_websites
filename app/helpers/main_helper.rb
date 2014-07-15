module MainHelper
  
  def feature_button(feature)
    if feature.string_value.blank?
      image_tag(feature.slide.url)
    else
      if feature.string_value =~ /^http\:/i 
        link_to(image_tag(feature.slide.url, class: "no-resize"), feature.string_value, target: "_blank")
      elsif feature.string_value =~ /^\//
        link_to(image_tag(feature.slide.url, class: "no-resize"), feature.string_value)
      else
        link_to(image_tag(feature.slide.url, class: "no-resize"), "/#{params[:locale]}/#{feature.string_value}")
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
        i = 0
	      y = YouTubeIt::Client.new
        v = y.videos_by(user: youtube_user)
        v.videos.each do |video|
          unless i >= limit
            thumbnail = video.thumbnails.find(height: 90).first
            link = play_video_url(video_id(video))
            # detail = truncate(video.html_content, length: 100)
            if style == "table"
              ret += "<tr>"
              ret +=   "<td><div style='margin-left: auto; margin-right: auto; position: relative; width:120px; height:90px'>"
              ret +=     "<img src='#{thumbnail.url}' width='120' height='90'/>"
              ret +=     "<div style='position:absolute; bottom: 0px; right: 6px; z-index: 1; color: white; font-size: 80%'>"
              ret +=     seconds_to_MS(video.duration)
              ret +=     "</div>"
              ret +=     "<div style='position:absolute; top: 30px; left: 45px; z-index: 1'>"
              ret +=        link_to(image_tag("play.png", alt: video.title), play_video_url(video_id(video)))
              ret +=     "</div>"
              ret +=   "</div></td>"
              ret +=   "<td class='preview'><p><b>"
              ret +=   link_to(video.title, play_video_url(video_id(video)))
              ret +=   "</b></p></td>"
              ret += "</tr>"
            else
              ret += "<div class='video_thumbnail'>"
              ret +=     link_to("<img src='#{thumbnail.url}' width='180' height='135'/>".html_safe, play_video_url(video_id(video)))
              ret +=     content_tag(:div, truncate(video.title))
              ret +=     content_tag(:div, seconds_to_MS(video.duration), class: 'video_duration')
              ret +=     content_tag(:div, link_to(image_tag("play.png", alt: video.title), play_video_url(video_id(video))), class: 'play_button')
              ret += "</div>"
            end
            i += 1
          end
	      end
	      ret += (style == "table") ? "</table>" : "</div>"
        raw(ret)
      rescue
        if !youtube_user.blank?
          # if File.exists?(Rails.root.join("app", "assets", "images", website.folder, I18n.locale, "youtube_button.png")) 
          #   link_to(image_tag("#{website.folder}/#{I18n.locale}/youtube_button.png", alt: "youtube"),
          #     "http://www.youtube.com/user/#{youtube_user}",
          #     target: "_blank")
          # else
            link_to("YouTube Channel", "http://www.youtube.com/user/#{youtube_user}", target: "_blank")
          # end
        end
      end
    end
  end

  def horizontal_youtube_feed(youtube_user, options)
    limit = options[:limit] || 4
    if youtube_user
      begin
        ret = '<ul id="video_list" class="large-block-grid-4 small-block-grid-2">'
        i = 0
        y = YouTubeIt::Client.new
        v = y.videos_by(user: youtube_user)
        v.videos.each do |video|
          unless i >= limit
            thumbnail = video.thumbnails.find(height: 90).first
            link = play_video_url(video_id(video))
            # detail = truncate(video.html_content, length: 100)
            ret += "<li class='video_thumbnail'>"
            ret +=     content_tag(:div, link_to(image_tag("play.png", alt: video.title), play_video_url(video_id(video))), class: 'play_button')
            ret +=     link_to("<img src='#{thumbnail.url}' width='180' height='135'/>".html_safe, play_video_url(video_id(video)))
            ret +=     content_tag(:div, link_to(video.title, play_video_url(video_id(video))), class: 'video_title')
            #ret +=     content_tag(:div, content_tag(:small, seconds_to_MS(video.duration)), class: 'video_duration')
            ret += "</li>"
            i += 1
          end
        end
        ret += "</ul>"
        raw(ret)
      rescue
        if !youtube_user.blank?
          link_to("YouTube Channel", "http://www.youtube.com/user/#{youtube_user}", target: "_blank")
        end
      end
    end    
  end

  def preload_background_images
    begin
      content = ""
      website.products.where("background_image_file_name IS NOT NULL").each do |product|
  		  content += image_tag(product.background_image.url("original", false), height: 0, width: 0)
  	  end
  	  content.html_safe
	  rescue
	    ""
    end
  end

  def featured_product_families(options={})
    default_options = {limit: 4}
    options = default_options.merge options

    loc = "#{I18n.locale}" # fixes odd bug

    out = ""
    out = "<ul class=\"large-block-grid-#{options[:limit]} small-block-grid-#{(options[:limit]/2).to_i}\">" if options[:zurb]

    @product_families = []
    ProductFamily.parents_with_current_products(website, I18n.locale).each do |product_family|
      @product_families << product_family unless product_family.hide_from_homepage?
    end
    pf_limit = options[:limit]

    @current_promotions ||= Promotion.all_for_website(website)

    if @current_promotions.count > 0
      out += "<li>" if options[:zurb]
      #if File.exists?(Rails.root.join("app", "assets", "images", website.folder, loc, "promotions.png"))
        out += link_to(image_tag("#{website.folder}/#{I18n.locale}/promotions.png", alt: "promotions"), promotions_path)
      #else
      #  out += content_tag(:div, link_to("#{loc} Promotions", promotions_path), class: "panel")
      #end
      out += "</li>" if options[:zurb]
      pf_limit = options[:limit] - 1
    elsif website.brand.name.match(/digitech/i) && @product_families.count < options[:limit]
      out += "<li>" if options[:zurb]
      out += link_to(image_tag("#{website.folder}/#{I18n.locale}/community.png", alt: "community"), community_path)
      out += "</li>" if options[:zurb]
      pf_limit = options[:limit] - 1
    end

    @product_families[0,pf_limit].each_with_index do |product_family, i| 
      hide_for_small = "hide-for-small" if i == pf_limit - 1 && !!(options[:limit] % 2)
      if product_family.family_photo_file_name.blank?
        sub_family_content = ""
        product_family.children.each do |sub_family|
          sub_family_content += content_tag(:h3, link_to(translate_content(sub_family, :name), sub_family)) +
            content_tag(:p, translate_content(sub_family, :intro) ) +
            link_to(t('view_full_line'), sub_family)
        end

        out += "<li class='#{hide_for_small}'>" if options[:zurb]
        out += content_tag(:div, id: product_family.to_param, class: 'product_family_feature') do
          content_tag(:h2, link_to(translate_content(product_family, :name), product_family)) +
          content_tag(:p, translate_content(product_family, :intro)) +
          link_to(t('view_full_line'), product_family) + raw(sub_family_content)
        end
        out += "</li>" if options[:zurb]

      else

        if options[:zurb]
          out += content_tag :li, link_to(image_tag(product_family.family_photo.url, alt: product_family.name), product_family), class: hide_for_small
        else
          out += content_tag :span, class: "family_button" do
            link_to(product_family) do
              image_tag(product_family.family_photo.url, alt: product_family.name)
            end
          end
        end

      end
    end
  
    out += "</ul>" if options[:zurb]
    out.to_s.html_safe
  end
  
end

