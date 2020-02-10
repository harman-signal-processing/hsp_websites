# This was a one-time fix. I accidentally broke paperclip attachments by
# trying to refresh a single style. That led to one style in a folder, but the
# original file was in its original folder. So, this finds any Settings whose
# slides are broken (the s3 key can't be found). Then it finds a matching s3
# key with a different timestamp and copies that object to the missing one.
namespace :s3fix do

  task paperclips: :environment do
    s3 = Aws::S3::Resource.new
    bucket = s3.bucket(Rails.configuration.aws[:bucket])
    s3_slides = bucket.objects(prefix: "settings/slides")

    # First, find paperclips missing their keys
    Setting.where("slide_file_name != ''").each do |setting|
      if !setting.slide.s3_object.exists?
        key_parts = setting.slide.s3_object.key.split(/_/)
        original_filename = setting.slide.path.match(/\/+([^\/]*)$/)[1]

        puts "Trying to fix #{ setting.name } (ID: #{setting.id})"
        # Try to find a match
        matches = {}
        s3_slides.each do |item|
          if item.key.match(/#{key_parts[0]}\_(\d*)\/#{original_filename}/)
            matches[$1] = item
          end
        end

        if matches.length > 0
          best_match = matches[matches.keys.sort.first]
          puts "!!!!!!! :) Found a match #{best_match.key} (#{matches.length} total matches)"
          bucket.object(setting.slide.s3_object.key).copy_from(best_match, acl: 'public-read')
        else
          puts "******* :( Could not find a match"
        end
      end
    end

  end
end
