namespace :registration do
  
  desc "export new warranty registrations"
  task :export_new => :environment do
    all = File.open(Rails.root.join("..", "..", "all_registrations.txt"), "a")
    File.open(Rails.root.join("..", "..", "new_registrations.txt"), "w+") do |fh|
      WarrantyRegistration.where(:exported => false).each do |reg|
        fh.puts reg.to_export
        all.puts reg.to_export
        reg.update_attributes(:exported => true)
      end
    end
    all.close
  end

  # Digitech's first registration in the database is 2011-03-21
  # lexicon's first registration in the database is 2012-06-18
  # DOD's first is 2012-09-08
  # dbx's first registration in the database is 2012-11-01

  desc "import old warranty registrations"
  task :import_old => :environment do 
    c = 0
    brand_starts = {
      "DIGITECH" => "2011-03-21".to_date,
      "LEXICON" => "2012-06-18".to_date,
      "DOD" => "2012-09-08".to_date,
      "DBX" => "2012-11-01".to_date,
      "BSS" => "2020-01-01".to_date
    }
    brands = {}
    File.open(Rails.root.join("..", "..", "all_registrations.txt")).each do |line|
      # if c < 400
        data = line.split("|")

        begin
        if data[15].present?
          data[15] = "DIGITECH" if data[15] == "HARDWIRE" || data[15] == "VOCALIST"
          brands[data[15]] ||= Brand.find(data[15].downcase)

          this_brand = brands[data[15]]
          this_date = data[19].to_date
          
          if data[19].blank? || this_date < brand_starts[data[15]])
            puts "Importing #{data[1]} #{data[2]} for #{this_brand.name}"
            c += 1
          else
            puts "Skipping #{data[1]} for #{this_brand.name}"
          end

        end
        rescue
          puts "Oh well, something weird happened"
        end

      # end

    end

    puts brands.inspect

  end
  
end