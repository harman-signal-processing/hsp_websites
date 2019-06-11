class Youtube
  class << self

    # These methods are a replacement for the youtube_it gem which did not work
    # with Google's Youtube API v3. (v2 is being phased out
    # and started having problems on 4/20/2015.)
    #
    def youtube_client
      @youtube_client ||= Google::APIClient.new(key: ENV['GOOGLE_YOUTUBE_API_KEY'],
        authorization: nil,
        application_name: "HSP-WWW",
        application_version: "1.0.0",
        user_agent: youtube_user_agent # likely won't be needed when upgrading google-api gem
      )
    end

    # Builds a custom user agent to prevent Google::APIClient to
    # use an invalid auto-generated one
    def youtube_user_agent
      [
        "HSP-Brandsites/1.0",
        "google-api-ruby-client/#{Google::APIClient::VERSION::STRING}",
        Google::APIClient::ENV::OS_VERSION,
        '(gzip)'
      ].join(' ').delete("\n")
    end

    def youtube_api
      @youtube_api ||= youtube_client.discovered_api('youtube', 'v3')
    end

    def get_video(video_id)
      video_info = youtube_client.execute!(
        api_method: youtube_api.videos.list,
        parameters: {
          part: 'snippet',
          limit: 1,
          id: video_id
        }
      )
      JSON.parse(video_info.body)["items"].first["snippet"]
    end

    def get_default_playlist_id(youtube_user)
      channel_info = youtube_client.execute!(
        api_method: youtube_api.channels.list,
        parameters: {
          part: "contentDetails",
          forUsername: youtube_user
        }
      )
      JSON.parse(channel_info.body)["items"].first["contentDetails"]["relatedPlaylists"]["uploads"]
    end

    def get_user_playlists(youtube_user)
      channel_id = get_youtube_channel_id(youtube_user)
      info = youtube_client.execute!(
        api_method: youtube_api.playlists.list,
        parameters: {
          part: "snippet",
          maxResults: 50,
          channelId: channel_id
        }
      )
      JSON.parse(info.body)["items"]
    end

    def get_specific_playlists(playlist_ids)
      info = youtube_client.execute!(
        api_method: youtube_api.playlists.list,
        parameters: {
          part: "snippet",
          id: playlist_ids
        }
      )
      JSON.parse(info.body)["items"]
    end

    def get_youtube_channel_id(youtube_user)
      info = youtube_client.execute!(
        api_method: youtube_api.channels.list,
        parameters: {
          part: "id",
          forUsername: youtube_user
        }
      )
      JSON.parse(info.body)["items"].first["id"]
    end

    def get_video_list_data(youtube_list_id, options)
      limit = options[:limit] || 4
      info = youtube_client.execute!(
        api_method: youtube_api.playlist_items.list,
        parameters: {
          part: "snippet",
          maxResults: limit,
          playlistId: youtube_list_id
        }
      )
      JSON.parse(info.body)
    end

  end
end
