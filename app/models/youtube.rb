require 'google/apis/youtube_v3'

class Youtube
  class << self

    def youtube_client
      @youtube_client ||= setup_client
    end

    def get_video(video_id)
      youtube_client.list_videos('snippet', id: video_id, limit: 1).items.first["snippet"]
    end

    def get_default_playlist_id(youtube_user)
      get_channels(youtube_user).items.first.content_details.related_playlists.uploads
    end

    def get_user_playlists(youtube_user)
      channel_id = get_youtube_channel_id(youtube_user)
      youtube_client.list_playlists("snippet", channel_id: channel_id, max_results: 50).items
    end

    def get_specific_playlists(playlist_ids)
      youtube_client.list_playlists("snippet", channel_id: playlist_ids).items
    end

    def get_youtube_channel_id(youtube_user)
      get_channels(youtube_user).items.first.id
    end

    def get_video_list_data(youtube_list_id, options)
      limit = options[:limit] || 4
      youtube_client.list_playlist_items('snippet', playlist_id: youtube_list_id, max_results: limit)
    end

    def get_channels(youtube_user)
      youtube_client.list_channels("contentDetails", for_username: youtube_user)
    end

    def setup_client
      service = Google::Apis::YoutubeV3::YouTubeService.new
      service.key = ENV['GOOGLE_YOUTUBE_API_KEY']
      service
    end

  end
end
