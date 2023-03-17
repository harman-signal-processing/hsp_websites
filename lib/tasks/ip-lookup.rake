require "csv"

namespace :ip do

  desc "Find location of IP address"
  task ip_lookup: :environment do
    
    # BEGIN TASK METHOD DEFINITIONS
    
    def get_ip_info(ip)
      remote_base_url = "http://ip-api.com/json/"
      url = "#{remote_base_url}#{ip}"
      filename = "/home/ubuntu/environment/tmp/_ip_info/ip_info.txt"
      
      # Check if IP address is already in file
      if File.foreach(filename).grep(/#{Regexp.quote(ip)}/).any?
        ip_info = JSON.parse(File.foreach(filename).grep(/#{Regexp.quote(ip)}/).first, object_class: OpenStruct)
        # puts "we have #{ip}"
        puts eval("we have #{ip}".inspect + ".green")
      else
        response = HTTParty.get(url)
        if response.success?
          ip_info = JSON.parse(response.to_json, object_class: OpenStruct)
          File.open(filename, "a") { |file| file.puts response.body }
          # puts "we had to go get #{ip}"
          puts eval("we had to go get #{ip}".inspect + ".yellow")
          sleep(2) # wait 2 seconds so we don't go over the ip-api.com request quota
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

    
    # ip = "2.57.122.246"
    # puts "getting ip info for: #{ip}"
    
    # ip_info = get_ip_info(ip)
    
    # file = "/home/ubuntu/environment/ips-to-lookup"
    # file = "/home/ubuntu/environment/tmp/lookup-russian-ips"
    file = "/home/ubuntu/environment/tmp/todays-ips"
    File.foreach(file) do |line|
      begin
        ip = line.gsub(/\n/,"")
        # binding.pry
        puts "getting ip info for: #{ip}"
        ip_info = get_ip_info(ip)
      rescue => e
        binding.pry
      end
    end  #  File.foreach(filename) do |line|

begin
          ip_is_present = !defined?(ip).nil?
          ip_info_is_present = !defined?(ip_info).nil?
          if ip_is_present && ip_info_is_present
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
rescue => e
binding.pry
end
    
    end_time = Time.now
    duration = ((end_time - start_time) / 1.minute).truncate(2)

    end_time_formatted = "#{end_time.month}/#{end_time.day}/#{end_time.year} #{end_time.strftime("%I:%M:%S %p")}"
    write_message(log, "Task finished at #{end_time_formatted} and lasted #{duration} minutes.")    
    
    # binding.pry
  end
  
end  #  namespace :ip do