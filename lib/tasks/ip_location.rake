require "csv"
require 'date'

namespace :ip do

  desc "Find location of IP address"
  task find_location: :environment do
    
    # BEGIN TASK METHOD DEFINITIONS
    
    def get_ip_info(ip)
      # remove any potential comma at the end of the ip
      ip = ip.gsub(",","")
      remote_base_url = "http://ip-api.com/json/"
      url = "#{remote_base_url}#{ip}"
      filename = "/home/ubuntu/environment/tmp/_ip_info/ip_info.txt"

      # Check if IP address is already in file
      if File.foreach(filename).grep(/#{Regexp.quote(ip)}/).any?
        ip_info = JSON.parse(File.foreach(filename).grep(/#{Regexp.quote(ip)}/).first, object_class: OpenStruct)
        puts eval("we have #{ip}".inspect + ".green")
      else
        # binding.pry
        if @last_request_time.present?
          # Check the time since the last request
          @time_since_last_request = Time.now - @last_request_time
          if @time_since_last_request < @min_request_interval
            sleep(@min_request_interval - @time_since_last_request)
          end  #  if @time_since_last_request < @min_request_interval
        end  #  if @last_request_time.present?
      
        response = HTTParty.get(url)
        if response.success?
          ip_info = JSON.parse(response.to_json, object_class: OpenStruct)
          File.open(filename, "a") { |file| file.puts response.body }
          puts eval("we had to go get #{ip}".inspect + ".yellow")
      
          # Update the last request time
          @last_request_time = Time.now
        else
          write_message(log, "Ah, oh! Trouble connecting to #{remote_base_url}#{ip}. Message: #{response.message}")
          return
        end
      end

      ip_info
    end  # def get_ip_info(ip)
    
    def write_message(log, message_to_output="", message_decoration="")
      if ENV["RAILS_ENV"] == "production"  # production doesn't have colorful puts
        puts message_to_output
      else
        puts eval(message_to_output.inspect + message_decoration)
      end
      log.info message_to_output
    end  #  def message(message)
        
    # END TASK METHOD DEFINITIONS
    
    # TASK WORK BEGINS HERE AND CAN CALL THE METHODS DEFINED ABOVE WITHOUT WORRY OF THE METHODS BEING ADDED TO THE GLOBAL NAMESPACE
    t = Time.now.localtime(Time.now.in_time_zone('America/Chicago').utc_offset)
    filename = "ip_location.#{t.month}.#{t.day}.#{t.year}_#{t.strftime("%I.%M.%S_%p")}.log"
    log = ActiveSupport::Logger.new("log/#{filename}")
    start_time = Time.now
    
    
    
    # need to wait 1.5 seconds between calls, there is a 45 calls per minute quota
    # https://ip-api.com/docs/api:json
    
    # read the banned_ips file
    # loop through each
    # call to get ip info
    # wait 1.5 to 2 seconds between cals
    # write each to csv file
    
      # Define the minimum interval between HTTP requests
      @min_request_interval = 2 # seconds    
    
    
      # Define the filename of the existing CSV file
      existing_csv_file = "tmp/_banned_ips_data/banned_ips_deduped_with_datetime.csv"
      
      last_timestamp_of_existing_csv_file = nil
      # Read the last line of the existing CSV file and parse the timestamp
      last_line = `tail -n 1 "#{existing_csv_file}"`
      last_line_datetime_str = last_line.split(',')[0]
      last_timestamp_of_existing_csv_file = DateTime.parse(last_line_datetime_str)

      
      # Define the filename of the new data file
      new_data_file = Rails.root.join("tmp/_banned_ips_data/banned_ips_deduped_with_datetime_sorted")
      
      ## Open a new CSV file to write the filtered data
      # new_csv = CSV.open(existing_csv_file + ".new", "wb")
      csv_file_to_update = CSV.open(existing_csv_file, "a")
      # 
      ## Write the headers to the new CSV file
      # headers = ["datetime","jail","status","server","ip","country","countryCode","region","regionName","city","zip","lat","lon","timezone","isp","org","as"]
      # new_csv << headers
      
      # Read the new data and write the filtered data to the new CSV file
      File.foreach(new_data_file) do |row|
        items = row.gsub(/\n/,"").split("|")
        datetime = items[0].strip
        jail = items[1].strip
        status = items[2].strip
        server = items[3].strip
        ip = items[4].strip
      
        # Check if the timestamp of the current line is greater than the timestamp of the last line in the existing CSV file
        current_timestamp = DateTime.parse(datetime)
        if last_timestamp_of_existing_csv_file.nil? || current_timestamp > last_timestamp_of_existing_csv_file
          # binding.pry
          # puts "getting ip info for: #{ip}"
          puts eval("getting ip info for: #{ip}".inspect + ".blue")
          ip_info = get_ip_info(ip)
          puts "#{datetime} - #{jail} - #{status} - #{server} - #{ip_info.query} - #{ip_info.country} - #{ip_info.countryCode} - #{ip_info.region} - #{ip_info.regionName} - #{ip_info.city} - #{ip_info.zip} - #{ip_info.lat} - #{ip_info.lon} - #{ip_info.timezone} - #{ip_info.isp} - #{ip_info.org} - #{ip_info.as} "
          puts
          # Write the current line to the new CSV file
          # new_csv << [datetime, jail, status, server, ip_info.query, ip_info.country, ip_info.countryCode, ip_info.region, ip_info.regionName, ip_info.city, ip_info.zip, ip_info.lat, ip_info.lon, ip_info.timezone, ip_info.isp, ip_info.org, ip_info.as]
          csv_file_to_update << [datetime, jail, status, server, ip_info.query, ip_info.country, ip_info.countryCode, ip_info.region, ip_info.regionName, ip_info.city, ip_info.zip, ip_info.lat, ip_info.lon, ip_info.timezone, ip_info.isp, ip_info.org, ip_info.as]
        end
      end
      
      # Close the new CSV file
      # new_csv.close
      csv_file_to_update.close
      
      # Replace the existing CSV file with the new CSV file
      # File.delete(existing_csv_file)
      # File.rename(existing_csv_file + ".new", existing_csv_file)

            
      if defined?(ip) && defined?(ip_info)
        write_message(log, "#{ip}")
        write_message(log, "#{ip_info.country}")
        write_message(log, "#{ip_info.countryCode}")
        write_message(log, "#{ip_info.region}")
        write_message(log, "#{ip_info.regionName}")
        write_message(log, "#{ip_info.city}")
        write_message(log, "#{ip_info.zip}")
        write_message(log, "#{ip_info.lat}")
        write_message(log, "#{ip_info.lon}")
        write_message(log, "#{ip_info.timezone}")
        write_message(log, "#{ip_info.isp}")
        write_message(log, "#{ip_info.org}")
        write_message(log, "#{ip_info.as}")
      end
    
    
    end_time = Time.now
    duration = ((end_time - start_time) / 1.minute).truncate(2)

    end_time_formatted = "#{end_time.month}/#{end_time.day}/#{end_time.year} #{end_time.strftime("%I:%M:%S %p")}"
    write_message(log, "Task finished at #{end_time_formatted} and lasted #{duration} minutes.")    
    
    # binding.pry
  end
  
end  #  namespace :ip do