require 'json'
require 'nokogiri'
require 'open-uri'

class Youtube

  def initialize(youtube_user="")
    @youtube_user = youtube_user
    @base_url = "https://www.youtube.com"
  end

  def get_videos(options={})
    limit = options[:limit] || 99

    videos = []
    videos_json['contents']['twoColumnBrowseResultsRenderer']['tabs'][1]['tabRenderer']['content']['sectionListRenderer']['contents'][0]['itemSectionRenderer']['contents'][0]['gridRenderer']['items'][0, limit].each do |item|
      video = item['gridVideoRenderer']
      if video['videoId'].present?
        videos << {
          id: video['videoId'],
          thumbnail: video['thumbnail']['thumbnails'].last['url'],
          title: video['title']['simpleText']
        }
      end
    end

    videos
  end

  def user_page
    @user_page ||= Nokogiri::HTML(URI.open("https://www.youtube.com/user/#{@youtube_user}/videos"))
  end

  def videos_json
    json = {}
    user_page.search("script").each do |script|
      if script.text.scan(/var ytInitialData/).length > 0
        text = script.text
        text.gsub!(/var ytInitialData \=/, "")
        text.gsub!(/\;/, "")
        json = JSON.parse(text)
      end
    end

    json
  end

end

