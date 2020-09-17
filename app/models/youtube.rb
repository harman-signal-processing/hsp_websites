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
    page = Nokogiri::HTML(URI.open("https://www.youtube.com/user/#{@youtube_user}/videos"))

    json = {}
    page.search("script").each do |script|
      if script.text.scan(/window\[\"ytInitialData\"\] \=/).length > 0
        text = script.text.split(/\n/)[0,2].join
        text.gsub!(/window\[\"ytInitialData\"\] \=/, "")
        text.gsub!(/\;/, "")
        json = JSON.parse(text)
      end
    end

    videos = []
    json['contents']['twoColumnBrowseResultsRenderer']['tabs'][1]['tabRenderer']['content']['sectionListRenderer']['contents'][0]['itemSectionRenderer']['contents'][0]['gridRenderer']['items'][0, limit].each do |item|
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

end

