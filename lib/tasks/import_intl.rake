namespace :intl do
  
  desc "Imports international distributors from old site's data"
  task :import => :environment do
    countries = load_countries
    brand = Brand.find_by_name("dbx")
    File.open(Rails.root.join("db", "intdistserv.txt")).each do |row|
      fields = row.split("\t")
      if fields[13].to_i > 0   # 10 = digitech, 11 = dod, 12 = johnson, 13 = dbx
        unless fields[14].blank?
          address = fields[1]
          address += "<br/>#{fields[2]}" unless fields[2].blank?
          address += "<br/>#{fields[3]} #{fields[4]} #{fields[5]}"
          address += "<br/>#{fields[6]}"
          address += "<br/>#{fields[7]}" unless fields[7].blank?
          address += "<br/>fax: #{fields[8]}" unless fields[8].blank?
          address += "<br/><a href=\"mailto:#{fields[9]}\">#{fields[9]}</a>" unless fields[9].blank?
          unless fields[15].blank?
            url = (fields[15] =~ /^http/i) ? fields[15] : "http://#{fields[15]}"
            address += "<br/><a href=\"#{url}\" target=\"_blank\">#{fields[15]}</a>"
          end
          address += "<p>#{fields[16]}</p>" unless fields[16].blank?
          country_codes = fields[14].split(",")
          country_codes.each do |c|
            if cname = countries[c] 
              d = Distributor.find_or_create_by_name_and_detail_and_country(fields[0], address, cname)
              BrandDistributor.find_or_create_by_distributor_id_and_brand_id(d.id, brand.id)
            end
          end
        end
      end
    end
  end
  
  def load_countries
    c = {}
    File.open(Rails.root.join("db", "countries.dat")).each do |row|
      fields = row.split("|")
      c[fields[0]] = fields[1]
    end
    c
  end
  
end