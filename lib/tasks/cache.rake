namespace :cache do
  
  desc "Clear the homepage fragment caches"
  task :refresh_homepage => :environment do 
    Website.all.each do |website|
      w = ActionController::Base.new
      w.expire_fragment("#{website.brand_name}_twitter_feed")
      w.expire_fragment("#{website.url}_youtube_feed")
      w.expire_fragment("#{website.brand_name}_youtube_feed")
      website.list_of_available_locales.each do |locale|
        w.expire_fragment("homepage_features_#{website.brand_id}_#{locale}")
      end
      @youtube_user = website.value_for('youtube').to_s.match(/\w*$/).to_s
      @youtube_client = YouTubeIt::Client.new
      if playlist_ids = website.value_for("playlist_ids")
        begin
          playlist_ids.split(/,\s?/).each do |playlist|
            @youtube_client.playlist(playlist).videos.each do |video|
              video.player_url =~ /v=([^\&]*)/
              w.expire_fragment("yt_row_#{$1}")
              w.expire_fragment("yt_side_bar_#{$1}")
            end
          end
        rescue
          puts "Could not clear video cache"
        end
      end
    end
  end
  
end