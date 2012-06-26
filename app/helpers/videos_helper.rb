module VideosHelper
  
  def video_id(video)
    video.player_url =~ /v=([^\&]*)/
    return $1
  end
  
  def favorites_except(not_this_video_id, youtube_client, youtube_user, max=6)
    other_videos = [] 
    youtube_client.videos_by(:favorites, :user => youtube_user).videos.each do |video|
      other_videos << video unless other_videos.size >= max || video.video_id.match(/#{not_this_video_id}/)
    end
    other_videos
  end
  
  def related_product_links_for_video(video)
    products = []
    if video.keywords && video.keywords.is_a?(Array)
      video.keywords.each do |tag|
        begin
          if p = Product.find(tag.downcase.gsub(/\s/, "-"))
            products << link_to(p.name, p) if p.show_on_website?(website)
          end
        rescue
          # logger.debug "Record not found for #{tag.downcase.gsub(/\s/, '-')}"
        end
      end
    end
    if products.size > 0
      raw("<p><b>Related Products:</b> #{products.join(', ')}</p>")
    else
      ""
    end
  end
end
