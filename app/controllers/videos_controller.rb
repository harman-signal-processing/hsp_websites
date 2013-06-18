class VideosController < ApplicationController
  before_filter :youtube_client
  
  # Split the "playlist_ids" setting by comma, retrieve each
  # playlist and show it in the browser
  def index
    @playlists = []
    @page_title = t('titles.youtube_channel', brand: website.brand_name)
    begin
      if playlist_ids = website.playlist_ids
        playlist_ids.split(/,\s?/).each do |playlist|
          @playlists << @youtube_client.playlist(playlist)
        end
      else
        @playlists << @youtube_client.videos_by(user: @youtube_user)
      end
      render_template
    rescue
      render text: "Error loading playlist"
    end
  end

  # Requires an ID. Since some of our videos come from 3rd parties, I can't
  # really verify that the provided video is official. Really, you could pass
  # any youtube video id and it should play here...not exactly desired.
  def play
    @video_id = params[:id]
    begin
      # @video = @youtube_client.video_by_user(@youtube_user, @video_id)
      @video = @youtube_client.video_by(@video_id)
      @page_title = @video.title
      render_template
    rescue
      redirect_to "http://youtube.com/watch?v=#{@video_id}" and return false
    end
  end
  
  private 
  
  def youtube_client
    @youtube_user = website.youtube.to_s.match(/\w*$/).to_s
    @youtube_client = YouTubeIt::Client.new
  end

end
