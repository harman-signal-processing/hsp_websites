module MainHelper
  
  def feature_button(feature)
    if feature.string_value.blank?
      image_tag(feature.slide.url)
    else
      if feature.string_value =~ /^http\:/i 
        link_to(image_tag(feature.slide.url), feature.string_value, :target => "_blank")
      elsif feature.string_value =~ /^\//
        link_to(image_tag(feature.slide.url), feature.string_value)
      else
        link_to(image_tag(feature.slide.url), "/#{params[:locale]}/#{feature.string_value}")
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
  def youtube_feed(youtube_user, style="table")
    limit = (style == "table") ? 4 : 3
    if youtube_user
      begin
	      ret = (style == "table") ? '<table class="news_list" style="margin-left: 20px">' : '<div id="video_list">'
        i = 0
	      y = YouTubeIt::Client.new
        v = y.videos_by(:user => youtube_user)
        v.videos.each do |video|
          # unless video.keywords.include?("HardWire") || i >= limit
            thumbnail = video.thumbnails.find(:height => 90).first
            link = play_video_url(video_id(video))
            # detail = truncate(video.html_content, :length => 100)
            if style == "table"
              ret += "<tr>"
              ret +=   "<td><div style='margin-left: auto; margin-right: auto; position: relative; width:120px; height:90px'>"
              ret +=     "<img src='#{thumbnail.url}' width='120' height='90'/>"
              ret +=     "<div style='position:absolute; bottom: 0px; right: 6px; z-index: 2000; color: white; font-size: 80%'>"
              ret +=     seconds_to_MS(video.duration)
              ret +=     "</div>"
              ret +=     "<div style='position:absolute; top: 30px; left: 45px; z-index: 2000'>"
              ret +=        link_to(image_tag("play.png", :alt => video.title), play_video_url(video_id(video)))
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
              ret +=     content_tag(:div, seconds_to_MS(video.duration), :class => 'video_duration')
              ret +=     content_tag(:div, link_to(image_tag("play.png", :alt => video.title), play_video_url(video_id(video))), :class => 'play_button')
              ret += "</div>"
            end
            i += 1
          # end
	      end
	      ret += (style == "table") ? "</table>" : "</div>"
        raw(ret)
      rescue
        if !youtube_user.blank?
          # if File.exists?(Rails.root.join("app", "assets", "images", website.folder, I18n.locale, "youtube_button.png")) 
          #   link_to(image_tag("#{website.folder}/#{I18n.locale}/youtube_button.png", :alt => "youtube"),
          #     "http://www.youtube.com/user/#{youtube_user}",
          #     :target => "_blank")
          # else
            link_to("YouTube Channel", "http://www.youtube.com/user/#{youtube_user}", :target => "_blank")
          # end
        end
      end
    end
  end

  def preload_background_images
    begin
      content = ""
      website.products.where("background_image_file_name IS NOT NULL").each do |product|
  		  content += image_tag(product.background_image.url("original", false), :height => 0, :width => 0)
  	  end
  	  content.html_safe
	  rescue
	    ""
    end
  end
  
end
