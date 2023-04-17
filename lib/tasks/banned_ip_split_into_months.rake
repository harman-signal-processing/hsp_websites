require 'csv'
require 'date'

namespace :banned_ips do

    desc 'Separate each month\'s data into a separate CSV file'
    task :split_data do
      # set the input and output file names
      input_file = 'tmp/_banned_ips_data/banned_ips_details_with_datetime.csv'
      jan_output_file = 'tmp/_banned_ips_data/jan_data.csv'
      feb_output_file = 'tmp/_banned_ips_data/feb_data.csv'
      mar_output_file = 'tmp/_banned_ips_data/mar_data.csv'
      apr_output_file = 'tmp/_banned_ips_data/apr_data.csv'
      may_output_file = 'tmp/_banned_ips_data/may_data.csv'
      jun_output_file = 'tmp/_banned_ips_data/jun_data.csv'
      jul_output_file = 'tmp/_banned_ips_data/jul_data.csv'
      aug_output_file = 'tmp/_banned_ips_data/aug_data.csv'
      sep_output_file = 'tmp/_banned_ips_data/sep_data.csv'
      oct_output_file = 'tmp/_banned_ips_data/oct_data.csv'
      nov_output_file = 'tmp/_banned_ips_data/nov_data.csv'
      dec_output_file = 'tmp/_banned_ips_data/dec_data.csv'
    
      # create empty arrays for each month
      jan_data = []
      feb_data = []
      mar_data = []
      apr_data = []
      may_data = []
      jun_data = []
      jul_data = []
      aug_data = []
      sep_data = []
      oct_data = []
      nov_data = []
      dec_data = []
    
      # read the input file into an array of hashes
      data = CSV.read(input_file, headers: true).map(&:to_h)
    
      header_row = ["datetime","server","jail","ip","country_nginx","country","country_code","region","region_name","city","zip","lat","lon","timezone","isp","org","as","banned_for","banned_count","attack_type","http_method","path","http_status","referrer","user_agent","hostname","error_message"]
    
      # loop through each row and add it to the appropriate month's array
      data.each do |row|
        # extract month part from date string
        date_str = row["datetime"]
        # binding.pry
        month = Date.parse(date_str).strftime('%b').downcase
        # add row to the appropriate month's array
        case month
        when 'jan'
          jan_data << row
        when 'feb'
          feb_data << row
        when 'mar'
          mar_data << row
        when 'apr'
          apr_data << row
        when 'may'
          may_data << row
        when 'jun'
          jun_data << row
        when 'jul'
          jul_data << row
        when 'aug'
          aug_data << row
        when 'sep'
          sep_data << row
        when 'oct'
          oct_data << row
        when 'nov'
          nov_data << row
        when 'dec'
          dec_data << row
        end
        
      end  #  data.each do |row|
    
      # write each month's data to a separate CSV file
      CSV.open(jan_output_file, 'w') do |csv|
        csv << header_row
        jan_data.each { |row| csv << row.values }
      end
      
      CSV.open(feb_output_file, 'w') do |csv|
        csv << header_row
        feb_data.each { |row| csv << row.values }
      end
    
      CSV.open(mar_output_file, 'w') do |csv|
        csv << header_row
        mar_data.each { |row| csv << row.values }
      end
    
      CSV.open(apr_output_file, 'w') do |csv|
        csv << header_row
        apr_data.each { |row| csv << row.values }
      end
      
      CSV.open(may_output_file, 'w') do |csv|
        csv << header_row
        may_data.each { |row| csv << row.values }
      end
      
      CSV.open(jun_output_file, 'w') do |csv|
        csv << header_row
        jun_data.each { |row| csv << row.values }
      end
      
      CSV.open(jul_output_file, 'w') do |csv|
        csv << header_row
        jul_data.each { |row| csv << row.values }
      end
      
      CSV.open(aug_output_file, 'w') do |csv|
        csv << header_row
        aug_data.each { |row| csv << row.values }
      end
      
      CSV.open(sep_output_file, 'w') do |csv|
        csv << header_row
        sep_data.each { |row| csv << row.values }
      end
      
      CSV.open(oct_output_file, 'w') do |csv|
        csv << header_row
        oct_data.each { |row| csv << row.values }
      end
      
      CSV.open(nov_output_file, 'w') do |csv|
        csv << header_row
        nov_data.each { |row| csv << row.values }
      end
      
      CSV.open(dec_output_file, 'w') do |csv|
        csv << header_row
        dec_data.each { |row| csv << row.values }
      end
      
    end  #  task :split_data do

end  #  namespace :banned_ips do