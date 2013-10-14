require 'net/http'
require 'uri'

namespace :maintain do

  desc "Check online retailer links"
  task :buynow_links => :environment do
    OnlineRetailerLink.to_be_checked.limit(30).each { |link|
      test_and_update(link)
    }
  end
  
  desc "Check external links for product reviews"
  task :product_review_links => :environment do
    ProductReview.to_be_checked.limit(30).each { |review|
      test_and_update(review)
    }
  end

  desc "(Artist) copy paperclip attachments to a new scheme"
  task :move_paperclips => :environment do
    old_path_interpolation = ":rails_root/public/system/:attachment/:id/:style/:filename"
    new_path_interpolation = ":rails_root/public/system/:attachment/:id_:timestamp/:basename_:style.:extension"

    Artist.all.each do |i|
      if i.artist_product_photo_file_name.present?
        attachment = i.artist_product_photo
        styles = [:original] + attachment.styles.map{|k,v| k}
        styles.each do |style|
          old_file_path = Paperclip::Interpolations.interpolate(old_path_interpolation, attachment, style) #see paperclip docs
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

  desc "(ARtist) remove old paperclips after migrating to a new path"
  task :delete_old_paperclips => :environment do 
    old_path_interpolation = ":rails_root/public/system/:attachment/:id/:style/:filename"
    new_path_interpolation = ":rails_root/public/system/:attachment/:id_:timestamp/:basename_:style.:extension"
    Artist.all.each do |i|
      if i.artist_photo_file_name.present?
        problems = []
        attachment = i.aritst_photo
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
  
  def test_and_update(item)
    begin
      new_status = link_test(item.url)
    rescue
      new_status = 500 # something bad happened with our link checker, flag it and move on
    end
    item.update_attributes(:link_checked_at => Time.now, :link_status => new_status)  
    sleep(15) # Don't crash others' sites.  
  end
  
  def link_test(url)
    uri = URI.parse(url)
    # response = nil
    # Net::HTTP.start(uri.host, uri.port) { |http|
    #   response = http.head(uri.path.size > 0 ? uri.path : "/")
    # }  

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request["User-Agent"] = "Harman link verifier. Contact adam.anderson@harman.com"
    response = http.request(request)

    # For some reason, that code above doesn't work on GC
    if response.code.to_s == "403"
      # http = Net::HTTP.new(uri.host, uri.port)
      response = http.request_head(uri.path)
    end

    response.code
  end

end