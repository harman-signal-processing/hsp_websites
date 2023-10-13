module YoutubeVideo

  def embed_url
    "#{base_url}#{youtube_id.strip!}?enablejsapi=1"
  end

  def is_playlist?
    youtube_id.start_with?('PL')
  end

  private

  def base_url
    url = "https://www.youtube.com/embed/"
    url += "videoseries?list=" if is_playlist?
    url
  end

end
