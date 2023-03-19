require 'sqlite3'
require 'json'

namespace :banned_ips do
  
    # Function to add a header row to a CSV file if it does not contain one
    def add_header_if_missing(csv_file, header_row)
      first_row = CSV.read(csv_file).first
      return if first_row == header_row
    
      CSV.open("temp.csv", "wb") do |csv_out|
        csv_out << header_row
        CSV.foreach(csv_file) { |row| csv_out << row }
      end
      FileUtils.mv("temp.csv", csv_file)
    end  #  def add_header_if_missing(csv_file, header_row)
    
    # Function to remove the header row from a CSV file if it contains one
    def remove_header_if_present(csv_file, header_row)
      first_row = CSV.read(csv_file).first
      return unless first_row == header_row
    
      CSV.open("temp.csv", "wb") do |csv_out|
        CSV.foreach(csv_file).with_index do |row, index|
          next if index.zero?
          csv_out << row
        end
      end
      FileUtils.mv("temp.csv", csv_file)
    end  #  def remove_header_if_present(csv_file, header_row)  
  
  task read_sqlite3_file: :environment do
    
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
    
    def process_db_rows(row, csv_file_to_update,server)
      jail = row[0]
      ip = row[1]
      datetime = row[2]
      banned_for = row[3]
      banned_count = row[4]
      ban_details = row[5]
      details = JSON.parse(ban_details)['matches']
      details_string = details.join(',')
      server = server
      
      puts eval("getting ip info for: #{ip}".inspect + ".blue")
      ip_info = get_ip_info(ip)
      country = ip_info.country
      country_code = ip_info.countryCode
      region = ip_info.region
      region_name = ip_info.regionName
      city = ip_info.city
      zip = ip_info.zip
      lat = ip_info.lat
      lon = ip_info.lon
      timezone = ip_info.timezone
      isp = ip_info.isp
      org = ip_info.org
      as = ip_info.as
      puts "#{datetime} - #{jail} - #{ip_info.query} - #{ip} - #{country} - #{region} - #{region_name} - #{city} - #{zip} - #{lat} - #{lon} - #{timezone} - #{isp} - #{org} - #{as} "
      
      # these get filled above
      # datetime,jail,ip,banned_for,banned_count
      
      # these will get filled below
      attack_type =""
      http_method =""
      path =""
      http_status =""
      referrer =""
      user_agent =""
      hostname =""
      error_message =""
      
    # This regular expression pattern is used to match a log data string that follows the following format:
    # "ip_address - country - - [timestamp] "http_method path http_version" http_status response_size "referrer" "user_agent" "load_balancer"~~ hostname"
    # The pattern uses named captures to extract the components of the log data string.
    
    # We use named captures in the regular expression pattern to extract the components of the log data string. 
    # Each named capture is enclosed in (?<name>) parentheses and given a name, making it easy to extract the 
    # matched values using the [] operator on the resulting MatchData object.  
  
    # ^                       Start of string
    # (?<ip_address>[\d\.]+)    Named capture for IP address: matches one or more digits or dots
    # -                         Match a dash
    # (?<country>.+?)          Named capture for country: matches one or more characters (non-greedy)
    # -                         Match a dash
    # -                         Match two dashes
    # \[(?<timestamp>.+)\]     Named capture for timestamp: matches one or more characters inside square brackets
    # "                         Match a double quote
    # (?<http_method>.+?)      Named capture for HTTP method: matches one or more characters (non-greedy)
    #                           (e.g. GET, POST, etc.)
    #                           The ? after the + makes it non-greedy, which means it matches as few characters as possible
    #                           to satisfy the pattern
    #                           (e.g. if there are multiple spaces between the HTTP method and the path, this will match
    #                           only the HTTP method and leave the rest for the next named capture)
    # (?<path>.+?)             Named capture for path: matches one or more characters (non-greedy)
    #                           (e.g. /wp-content/plugins/elementor/assets/js/frontend.min.js)
    #                           The ? after the + makes it non-greedy, which means it matches as few characters as possible
    #                           to satisfy the pattern
    # (?<http_version>.+?)     Named capture for HTTP version: matches one or more characters (non-greedy)
    #                           (e.g. HTTP/1.1)
    #                           The ? after the + makes it non-greedy, which means it matches as few characters as possible
    #                           to satisfy the pattern
    # "                         Match a double quote
    # (?<http_status>\d+)      Named capture for HTTP status: matches one or more digits
    #                           (e.g. 200, 404, etc.)
    # (?<response_size>\d+)    Named capture for response size: matches one or more digits
    #                           (e.g. 559)
    # "                         Match a double quote
    # (?<referrer>.*?)         Named capture for referrer: matches zero or more characters (non-greedy)
    #                           (e.g. - or http://example.com)
    #                           The ? after the * makes it non-greedy, which means it matches as few characters as possible
    #                           to satisfy the pattern
    # "                         Match a double quote
    # (?<user_agent>.*?)       Named capture for user agent: matches zero or more characters (non-greedy)
    #                            (e.g. Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.0 Safari/537.36)
    #                            The ? after the * makes it non-greedy, which means it matches as few characters as possible
    #                            to satisfy the pattern
    # "                          Match a double quote
    # (?<load_balancer>.*?)    Named capture for load balancer: matches zero or more characters (non-greedy)
    #                           (e.g. load_balancer=10.159.22.9)
    #                           The ? after the * makes it non-greedy, which means it matches as few characters as possible
    #                           to satisfy the pattern
    # "                         Match a double quote
    # ~~                        Match a double tilde
    # (?<hostname>.+)$         Named capture for hostname: matches one or more characters until the end of the string
    #                           (e.g. audioarchitect.harmanpro.com)
  
  case jail
  when "rails-brandsites-bad-actors"
    pattern = /^(?<ip_address>[\d\.]+) - - \[(?<timestamp>,\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}, [AP]M)\] "(?<attack_type>[^"]+)" ~~ #<ActionDispatch::Request (?<http_method>[A-Z]+) "(?<path>[^"]+)" for (?<request_ip_address>[\d\.]+)>$/
    # "114.30.18.65 - - [,2023-03-10 12:08:10, AM] \"POSTing JSON\" ~~ #<ActionDispatch::Request POST \"https://www.martin.com/en-US/support/warranty_registration\" for 114.30.18.65>"
    #   /^
    #   (?<ip_address>[\d\.]+) - - 
    #   \[(?<timestamp>,\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}, [AP]M)\] 
    #   "(?<attack_type>[^"]+)" ~~ #<ActionDispatch::Request 
    #   (?<http_method>[A-Z]+) 
    #   "(?<path>[^"]+)" 
    #   for 
    #   (?<request_ip_address>[\d\.]+)
    #   >$/
    
        #  Let's examine each part of the pattern in more detail:
        #  
        #  ^ - 
        #  (?<ip_address>[\d\.]+) - This part of the pattern uses a named capture group ip_address to match any sequence of digits (\d) or dots (\.). This is used to capture the client's IP address.
        #  - - - This matches the two dashes between the client IP address and the timestamp.
        #  \[ - This matches the opening square bracket for the timestamp.
        #  (?<timestamp>,\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}, [AP]M) - This is a named capture group timestamp that matches the date and time of the request. It matches a comma, followed by a four-digit year (\d{4}), a two-digit month (\d{2}), a two-digit day (\d{2}), a space, a two-digit hour (\d{2}), a colon, a two-digit minute (\d{2}), a colon, a two-digit second (\d{2}), a comma, a space, and either AM or PM.
        #  \] - This matches the closing square bracket and space after the timestamp.
        #  "(?<attack_type>[^"]+)" - This is a named capture group attack_type that matches any non-empty sequence of characters that are not double quotes ("). This is used to capture the type of attack.
        #  ~~ #<ActionDispatch::Request - This matches a fixed string ~~ #<ActionDispatch::Request that appears after the attack type in the log line.
        #  (?<http_method>[A-Z]+) - This is a named capture group http_method that matches any sequence of one or more uppercase letters (A-Z). This is used to capture the HTTP method used in the request.
        #  "(?<path>[^"]+)" - This is a named capture group path that matches any non-empty sequence of characters that are not double quotes ("). This is used to capture the path of the requested resource.
        #  for - This matches the fixed string for that appears after the path in the log line.
        #  (?<request_ip_address>[\d\.]+) - This is a named capture group request_ip_address that matches any sequence of digits (\d) or dots (\.). This is used to capture the IP address of the server that fulfilled the request.
        #  >$ - This matches the end of the line.    
    
    match = pattern.match(details_string)
    
    begin
        ip_address = match[:ip_address]
        # binding.pry
    rescue => e 
      binding.pry
      puts "Error (rails-brandsites-bad-actors): ------------- #{e}"
      puts ban_details
    end     
    
    attack_type = match[:attack_type]
    timestamp = match[:timestamp]    
    
    http_method = match[:http_method]
    path = match[:path]
    path = path.truncate(200)
    
  when "manual-ban"
    # no pattern
  when "rails-brandsites-500"
    # pattern = /^(?<ip_address>[\d\.]+) - - \[(?<timestamp>,\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}, [AP]M)\] "(?<http_method>.+?) (?<path>.+?)" "REFERER (?<referrer>.+?)" "ERROR (?<error_message>.*)"$/
    
    # this works
    # pattern = /^(?<ip_address>[\d\.]+) - - \[(?<timestamp>.*?)\]/
    
    # this works
    # pattern = /^(?<ip_address>[\d\.]+) - - \[(?<timestamp>.*?)\] "(?<http_method>.+?) (?<path>.+?)"/
    
    # this works
    # pattern = /^(?<ip_address>[\d\.]+) - - \[(?<timestamp>.*?)\] "(?<http_method>.+?) (?<path>.+?)" "REFERER (?<referrer>.+?)"/
    
    # this works
    # pattern = /^(?<ip_address>[\d\.]+) - - \[(?<timestamp>.*?)\] "(?<http_method>.+?) (?<path>.+?)" "ERROR (?<error_message>.+?)" /
    
    # does not work
    # pattern = /^(?<ip_address>[\d\.]+) - - \[(?<timestamp>.*?)\] "(?<http_method>.+?) (?<path>.+?)" "REFERER (?<referrer>.+?)" "ERROR (?<error_message>.+?)" /
    
    # this works
    pattern = /^(?<ip_address>[\d\.]+) - - \[(?<timestamp>.*?)\] "(?<http_method>.+?) (?<path>.+?)" "REFERER\s*(?<referrer>.*?)" "ERROR (?<error_message>.+?)" /

    
    # this worked
    # pattern = /^(?<ip_address>[\d\.]+)/
    details_for_rails_brandsites_500 = details[0].join(',').gsub("\\r\\n","")
    match = pattern.match(details_for_rails_brandsites_500)
    
    # binding.pry
    
    begin
        ip_address = match[:ip_address]
        # binding.pry
    rescue => e 
      binding.pry
      puts "Error (rails-brandsites-500): ------------- #{e}"
      puts ban_details
    end
    
    timestamp = match[:timestamp]    
    
    http_method = match[:http_method]
    path = match[:path]
    path = path.truncate(200)
    referrer = match[:referrer]
    error_message = match[:error_message]
    
  else
    # pattern = /^(?<ip_address>[\d\.]+) - (?<country>.+?) - - \[(?<timestamp>.+)\] "(?<http_method>.+?) (?<path>.+?) (?<http_version>.+?)" (?<http_status>\d+) (?<response_size>\d+) "(?<referrer>.*?)" "(?<user_agent>.*?)" "(?<load_balancer>.*?)" ~~ (?<hostname>.+)$/
    pattern = /^(?<ip_address>[\d\.]+) - (?<country>.+?) - (?<username>.+?) \[(?<timestamp>.+)\] "(?<http_method>.+?) (?<path>.+?) (?<http_version>.+?)" (?<http_status>\d+) (?<response_size>\d+) "(?<referrer>.*?)" "(?<user_agent>.*?)" "(?<load_balancer>.*?)" ~~ (?<hostname>.+)$/
    match = pattern.match(details_string)
    
    # binding.pry
    
    begin
        ip_address = match[:ip_address]
    rescue => e 
      binding.pry
      puts "Error (else): ------------- #{e}"
      puts ban_details
    end    
      country_nginx = match[:country]
      # timestamp = match[:timestamp].gsub(',', '').gsub(' +0000', '')
      timestamp_string = match[:timestamp].gsub(',', '').gsub(' +0000', '')
      # 2023-03-09 19:30:40
      
      timestamp = DateTime.strptime(timestamp_string, "%d/%b/%Y:%H:%M:%S")
      timestamp_formatted = timestamp.strftime("%Y-%m-%d %H:%M:%S")
    
      http_version = match[:http_version]
      http_status = match[:http_status]
      response_size = match[:response_size]
      referrer = match[:referrer]
      user_agent = match[:user_agent]
      load_balancer = match[:load_balancer]
      hostname = match[:hostname]
      
      http_method = match[:http_method]
      # path = match[:path]
      path = match[:path]
      # Wrap the path value in double quotes
      # path = "\"#{path}\""
      path = path.truncate(200)
      
  end  #  case jail
  
  
      puts "Jail: #{jail}"
      puts "IP: #{ip}"
      puts "Server: #{server}"
      puts "Country (nginx): #{country_nginx}"
      puts "Country (ip-api): #{country}"
      puts "Country Code: #{country_code}"
      puts "Region: #{region}"
      puts "Region Name: #{region_name}"
      puts "City: #{city}"
      puts "Zip: #{zip}"
      puts "Lat: #{lat}"
      puts "Lon: #{lon}"
      puts "Timezone: #{timezone}"
      puts "Isp: #{isp}"
      puts "Org: #{org}"
      puts "As: #{as}"
      puts "Datetime: #{datetime}"
      puts "Banned For: #{banned_for} days"
      puts "Times Banned: #{banned_count}"
      #puts "IP Address: #{ip_address}"
      #puts "Timestamp: #{timestamp_formatted}"
      puts "Attack Type: #{attack_type}"
      puts "HTTP Method: #{http_method}"
      puts "Path: #{path}"
      #puts "HTTP Version: #{http_version}"
      puts "HTTP Status: #{http_status}"
      # puts "Response Size: #{response_size}"
      puts "Referrer: #{referrer}"
      puts "User Agent: #{user_agent}"
      #puts "Load Balancer: #{load_balancer}"
      puts "Hostname: #{hostname}"
      puts "Error Message: #{error_message}"
      puts
      # puts details_string
      puts
      # binding.pry
      
      # puts row.inspect
      
            # Write the row data to the CSV file
      # csv << row
      # binding.pry if ip == "102.216.84.138"

      
            # binding.pry
          csv_file_to_update << [datetime,server,jail,ip,country_nginx,country,country_code,region,region_name,city,zip,lat,lon,timezone,isp,org,as,banned_for,banned_count,attack_type,http_method,path,http_status,referrer,user_agent,hostname,error_message]
            # binding.pry
    end  #  def process_db_rows
    
    def sql()
        sql_to_use = "select 
            jail, 
            ip, 
            strftime('%Y-%m-%d %H:%M:%S', 
            datetime(timeofban, 'unixepoch', 'localtime')) AS cst_timestamp, 
            bantime/86400 as days_banned, 
            bancount, 
            data 
        from bans 
        -- where jail='nginx-bad-request' 
        -- where jail='rails-brandsites-bad-actors' 
           --  and json_extract(data, '$.matches[0][2]') not like '%wp_login%' 
        order by timeofban;"
        
        sql_to_use
    end  # def sql
    

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
    filename = "banned_ip_databases.#{t.month}.#{t.day}.#{t.year}_#{t.strftime("%I.%M.%S_%p")}.log"
    log = ActiveSupport::Logger.new("log/#{filename}")
    start_time = Time.now
    
    # Define the minimum interval between HTTP requests to get external IP info lookup
    @min_request_interval = 2 # seconds
    
    header_row = ["datetime","server","jail","ip","country_nginx","country","country_code","region","region_name","city","zip","lat","lon","timezone","isp","org","as","banned_for","banned_count","attack_type","http_method","path","http_status","referrer","user_agent","hostname","error_message"]
    
    existing_csv_file = '/home/ubuntu/environment/tmp/_banned_ips_data/banned_ips_details_with_datetime.csv'
    
    remove_header_if_present(existing_csv_file, header_row)
    
      last_timestamp_of_existing_csv_file = nil
      # Read the last line of the existing CSV file and parse the timestamp
      last_line = `tail -n 1 "#{existing_csv_file}"`
      last_line_datetime_str = last_line.split(',')[0]
      last_timestamp_of_existing_csv_file = DateTime.parse(last_line_datetime_str)
    
    
  # Open the CSV file in append mode and create a CSV writer object
  CSV.open(existing_csv_file, 'a') do |csv_file_to_update|
    
    # Find all SQLite3 files in the directory
    Dir.glob("/home/ubuntu/environment/tmp/fail2ban/dbs/*.sqlite3") do |sqlite3_file|
        
            # Open the SQLite3 file
        db = SQLite3::Database.new(sqlite3_file)
        
        puts "========= #{sqlite3_file} =========="
        # binding.pry
        
        db.execute(sql) do |row|
          # binding.pry
          case sqlite3_file
          when /prod1/
            server = "aws-production1"
          when /prod2/
            server = "aws-production2"
          when /prod3/
            server = "aws-production3"
          end
          
          datetime_of_current_row = row[2]
          current_timestamp = DateTime.parse(datetime_of_current_row)
          # Only process the row if it is has a more recent timestamp than the last item in the existing_csv_file
          if last_timestamp_of_existing_csv_file.nil? || current_timestamp > last_timestamp_of_existing_csv_file
            process_db_rows(row, csv_file_to_update, server)
          end  #  if last_timestamp_of_existing_csv_file.nil? || current_timestamp > last_timestamp_of_existing_csv_file
          
          
          # binding.pry
        end  #  db.execute(sql) do |row|
    
        # Close the SQLite3 file
        db.close
    
    end   #  Dir.glob("/home/ubuntu/environment/tmp/fail2ban/dbs/*.sqlite3") do |sqlite3_file|
    
  end  # csv file open
  
  # Load the CSV data into an array of arrays
  csv_data = CSV.read(existing_csv_file)
  
  # Sort the data by the datetime in the first column
  sorted_data = csv_data.sort_by { |row| DateTime.parse(row[0]) }
  
  # Deduplicate the data by converting it to a set and then back to an array
  deduped_data = sorted_data.uniq  
  
  new_uniq_and_sorted_csv_file = '/home/ubuntu/environment/tmp/_banned_ips_data/banned_ips_details_with_datetime_sorted_depuped.csv'
  
  # Write the sorted and deduped data to the output file
  CSV.open(new_uniq_and_sorted_csv_file, 'w') do |csv|
    deduped_data.each do |row|
      csv << row
    end
  end
    
    # Now we make the new uniq and sorted file the main csv file
    FileUtils.mv(new_uniq_and_sorted_csv_file, existing_csv_file)
    
    add_header_if_missing(existing_csv_file, header_row)
    
    # TASK WORK FINISHED, NOW CALCULATE TASK TIME DURATION
    end_time = Time.now
    duration = ((end_time - start_time) / 1.minute).truncate(2)

    end_time_formatted = "#{end_time.month}/#{end_time.day}/#{end_time.year} #{end_time.strftime("%I:%M:%S %p")}"

    write_message(log, "Task finished at #{end_time_formatted} and lasted #{duration} minutes.")
    
  end  #  task :read_sqlite3_file do
  
  desc "Add a header row to a CSV file if it does not contain one"
  task :add_header, [:csv_file] do |_t, args|
    header_row = ["datetime","server","jail","ip","country_nginx","country","country_code","region","region_name","city","zip","lat","lon","timezone","isp","org","as","banned_for","banned_count","attack_type","http_method","path","http_status","referrer","user_agent","hostname","error_message"]
    add_header_if_missing(args.csv_file, header_row)
    puts "Header row added to #{args.csv_file} if it was missing"
  end
  
  desc "Remove the header row from a CSV file if it contains one"
  task :remove_header, [:csv_file] do |_t, args|
    header_row = ["datetime","server","jail","ip","country_nginx","country","country_code","region","region_name","city","zip","lat","lon","timezone","isp","org","as","banned_for","banned_count","attack_type","http_method","path","http_status","referrer","user_agent","hostname","error_message"]
    remove_header_if_present(args.csv_file, header_row)
    puts "Header row removed from #{args.csv_file} if it was present"
  end
  
end  #  namespace :banned_ips do