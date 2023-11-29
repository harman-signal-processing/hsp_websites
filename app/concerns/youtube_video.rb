require 'mechanize'

module YoutubeVideo

  def embed_url
    "#{base_url}#{youtube_id.strip}?enablejsapi=1"
  end

  def is_playlist?
    youtube_id.start_with?('PL')
  end

  def has_metadata?
    title.present? && duration_seconds.present?
  end

  def same_videos
    self.class.where(youtube_id: youtube_id).where.not(id: self.id)
  end

  def same_videos_with_metadata
    same_videos.where.not(title: nil, duration_seconds: nil)
  end

  private

  def base_url
    url = "https://www.youtube.com/embed/"
    url += "videoseries?list=" if is_playlist?
    url
  end

  def watch_url
    "https://www.youtube.com/watch?v=#{youtube_id}"
  end

  protected

  def sanitize_youtube_id
    if youtube_id.to_s.match?(/^http/)
      if youtube_id.match(/v\=(.*)$/)
        self.youtube_id = $1
      end
    end
  end

  # Fill in the title, description, duration_seconds and publish date
  def populate_metadata
    unless has_metadata? || is_playlist?
      if same_videos.size > 0 && same_videos_with_metadata.size > 0
        copy_metadata_from(same_videos_with_metadata.first)
      else
        populate_metadata_from_youtube
      end
      self.save if self.title_changed?
    end
  end
  handle_asynchronously :populate_metadata

  def copy_metadata_from(buddy)
    self.title            = buddy.title
    self.description      = buddy.description
    self.duration_seconds = buddy.duration_seconds
    self.published_on     = buddy.published_on
  end

  def populate_metadata_from_youtube
    begin
      agent = Mechanize.new
      page = agent.get(watch_url)
      self.title = page.title

      # Get rid of everything before "ytInitialPlayerResponse"
      part1 = page.content.split("ytInitialPlayerResponse = ").last
      # Get rid of everything after the next /script tag
      part2 = part1.split("</script>").first
      # Strip off any trailing semicolon
      raw_json = part2.gsub(/\;$/, "")
      # Parse what's left as JSON
      json = JSON.parse(raw_json)

      if json["playabilityStatus"] && json["playabilityStatus"]["status"]
        if json["playabilityStatus"]["status"] == "LOGIN_REQUIRED"
          self.title = "PRIVATE_VIDEO"
        elsif json["videoDetails"]
          self.description      = json["videoDetails"]["shortDescription"][0,200]
          self.duration_seconds = json["videoDetails"]["lengthSeconds"].to_i
          self.title            = json["videoDetails"]["title"]
          self.published_on     = json["microformat"]["playerMicroformatRenderer"]["publishDate"]
        end
      end
    rescue
    end
  end

  def update_same_videos
    if self.has_metadata?
      same_videos.where(title: nil, duration_seconds: nil).update_all({
        title: self.title,
        duration_seconds: self.duration_seconds,
        description: self.description,
        published_on: self.published_on
      })
    end
  end
end
