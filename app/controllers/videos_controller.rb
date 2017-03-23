class VideosController < ApplicationController

  # Split the "playlist_ids" setting by comma, retrieve each
  # playlist and show it in the browser
  def index
    @playlists = []
    @page_title = t('titles.youtube_channel', brand: website.brand_name)
    begin
      if playlist_ids = website.playlist_ids
        @playlists = get_specific_playlists(playlist_ids)
      else
        @playlists = get_user_playlists(youtube_user)
      end
      if @playlists.length == 0
        default_playlist_id = get_default_playlist_id(youtube_user)
        @playlists << get_specific_playlists(default_playlist_id)
      end
      render_template
    rescue
      if !youtube_user.blank?
        redirect_to "https://www.youtube.com/user/#{youtube_user}", status: :moved_permanently and return false
      else
        render text: "Error loading playlist"
      end
    end
  end

  # Requires an ID. Since some of our videos come from 3rd parties, I can't
  # really verify that the provided video is official. Really, you could pass
  # any youtube video id and it should play here...not exactly desired.
  def play
    @video_id = params[:id]
    begin
      @video = get_video(@video_id)
      @page_title = @video['title']
      render_template
    rescue
      redirect_to "https://youtube.com/watch?v=#{@video_id}", status: :moved_permanently and return false
    end
  end

  private

  def youtube_user
    @youtube_user ||= website.youtube.to_s.match(/\w*$/).to_s
  end

end
