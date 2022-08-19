class VideosController < ApplicationController

  def index
    if !youtube_user.blank?
      redirect_to "https://www.youtube.com/user/#{youtube_user}", allow_other_host: true, status: :moved_permanently and return false
    else
      render plain: "Error loading playlist"
    end
  end

  def play
    @video_id = params[:id]
    redirect_to "https://youtube.com/watch?v=#{@video_id}", allow_other_host: true, status: :moved_permanently and return false
  end

  private

  def youtube_user
    @youtube_user ||= website.youtube.to_s.match(/\w*$/).to_s
  end

end
