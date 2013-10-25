namespace :attachments do

  desc "copy paperclip attachments to a new scheme"
  task :move_paperclips => :environment do
    old_path_interpolation = ":rails_root/public/system/:attachment/:id/:style/:filename"
    new_path_interpolation = ":rails_root/public/system/:attachment/:id_:timestamp/:basename_:style.:extension"

    MarketingAttachment.all.each do |i|
      if i.marketing_file_file_name.present?
        attachment = i.marketing_file
        styles = [:original] + attachment.styles.map{|k,v| k}
        styles.each do |style|
          old_file_path = attachment.path(style) #Paperclip::Interpolations.interpolate(old_path_interpolation, attachment, style) #see paperclip docs
          new_file_path = Paperclip::Interpolations.interpolate(new_path_interpolation, attachment, style)

    puts "== Current file path:  #{old_file_path}"
    puts "== New file path:  #{new_file_path}"

          if File.exists?(old_file_path)
              if !File.exists?(new_file_path) #don't overwrite
                  FileUtils.mkdir_p(File.dirname(new_file_path)) #create folder if it doesn't exist
                  FileUtils.cp(old_file_path, new_file_path)
                  puts "==== File copied (^_^)"
              else
                  puts "==== File already exists in new location."
              end
          else
              puts "==== ! Real File Not Found ! "
          end
        end
      end
    end
  end

  desc "remove old paperclips after migrating to a new path"
  task :delete_old_paperclips => :environment do 
    old_path_interpolation = ":rails_root/public/system/:attachment/:id/:style/:filename"
    new_path_interpolation = ":rails_root/public/system/:attachment/:id_:timestamp/:basename_:style.:extension"
    MarketingAttachment.all.each do |i|
      if i.marketing_file_file_name.present?
        problems = []
        attachment = i.marketing_file
        styles = [:original] + attachment.styles.map{|k,v| k}
        styles.each do |style|
          old_file_path = Paperclip::Interpolations.interpolate(old_path_interpolation, attachment, style) #see paperclip docs
          new_file_path = Paperclip::Interpolations.interpolate(new_path_interpolation, attachment, style)

    puts "== Current file path:  #{old_file_path}"
    puts "== New file path:  #{new_file_path}"

          if File.exists?(new_file_path)
              if File.exists?(old_file_path) 
                  FileUtils.rm(old_file_path)
                  puts "==== File deleted (^_^)"
              else
                  puts "==== File already gone from location."
              end
          else
              problems << new_file_path
              puts "==== ! New file was Not Found ! "
          end
        end

        # Delete container for all styles for this attachment
        unless problems.count > 0
          d = Paperclip::Interpolations.interpolate(old_path_interpolation, attachment, attachment.default_style)
          container_folder = File.dirname(File.dirname(d))
          FileUtils.rm_rf(container_folder)
          puts "===== Deleting container: #{container_folder}"
        end

      end
    end
  end
 

	task :migrate_to_s3 => :environment do
		require 'aws/s3'

		# Load credentials
		s3_options = S3_CREDENTIALS
		bucket_name = 'harman-hsp-web-assets' #s3_options.delete("bucket")

		# Establish S3 connection
		s3 = AWS::S3.new(s3_options)
		bucket = s3.buckets[bucket_name]

    old_path_interpolation = ":rails_root/public/system/:attachment/:id_:timestamp/:basename_:style.:extension"
    new_path_interpolation = ":class/:attachment/:id_:timestamp/:basename_:style.:extension"

    ProductAttachment.all.each do |i|
      if i.product_media_thumb_file_name.present?
        attachment = i.product_media_thumb
        styles = [:original] + attachment.styles.map{|k,v| k}
        styles.each do |style|
          old_file_path = Paperclip::Interpolations.interpolate(old_path_interpolation, attachment, style) #see paperclip docs
					new_file_path = Paperclip::Interpolations.interpolate(new_path_interpolation, attachment, style)

    puts "== Current file path:  #{old_file_path}"
    puts "== New file path:  #{new_file_path}"

          if File.exists?(old_file_path)
						begin
							obj = bucket.objects[new_file_path.sub(%r{^/},'')]
							obj.write(Pathname.new(old_file_path), acl: :public_read, content_type: i.product_media_thumb_content_type)
						rescue AWS::S3::Errors::NoSuchBucket => e
							s3.buckets.create(bucket_name)
							retry
						rescue 
							raise
						end
						puts "Saved to S3"
          else
              puts "==== ! Real File Not Found ! "
          end

        end
      end
    end

	end
end