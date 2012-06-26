namespace :sap do
  
  desc "Import dealers from text file provided by SAP"
  task :import_dealers => :environment do
    puts "Importing..."
    brand = Brand.find_by_name("Lexicon")
    file = Rails.root.join("db", "lexicon.dat")
    keys = [:name, :name2, :name3, :name4, :address, :city, :state, :zip, :telephone, :fax, :email, :account_number]
    File.open(file).each do |row|
      d = {}
      row.chomp!.split(/\s?\|\s?/).each_with_index do |val, i|
        d[keys[i]] = val
      end
      dealer = Dealer.find_or_initialize_by_account_number_and_brand_id(d[:account_number], brand.id)
      dealer.attributes = d
      sleep(2) if dealer.new_record? || dealer.address_changed? # we had to geocode, so give Google a break for 4 seconds
      dealer.save! if dealer.changed?
    end
    puts "Total dealers in database: #{Dealer.count}"
  end
  
  desc "Determine which account numbers should be excluded (based on legacy keywords)"
  task :build_exclusion => :environment do
    puts "Finding exclusions"
    exclusions = []
    keywords = ["don't", 
    	"do not",
    	"deletion",
    	"deleted",
    	"closed",
    	"collection",
    	"credit",
    	"out of business",
    	"bankruptcy",
    	"inactive",
    	"freight",
    	"signal marketing",
    	"craig poole",
    	"eaton sales",
    	"meyer marketing",
    	"mars music",
    	"unknown",
    	"dig-",
    	"hmg",
    	"factory-",
    	"promo",
    	"1241 ROLLINS",
    	"DOBBS",
    	"HANOUD",
    	"ISLAND INSTRUMENTS",
    	"HP MARKETING",
    	"VISION2 MARKETING",
    	"NETWORK SALES",
    	"NORTHSHORE MARKETING",
    	"PLUS FOUR MARKETING",
    	"ROBERT LOUIS",
    	"SIGMET",
    	"INNOVATIVE AUDIO SALES / DIST",
    	"SOUND DISTRIBUTION & SALES",
    	"AVA -- DISTRIBUTION",
    	"AVA - DISTRIBUTION",
    	"AUDIO VIDEO ASSOC., INC.",
    	"EATON SALES",
    	"EDDIE KRAMER",
    	"GRIFFITH SALES",
    	"ONLINE MKTG. DIST",
    	"QUEST MARKETING",
    	"SEHI MARKETING",
    	"RS DISTRIBUTING",
    	"RS MARKETING",
    	"SALES GUY DISTRIBUTION",
    	"STRATEGY V ",
    	"SOUND MARKETING",
    	"JEFF PHILLIPS",
    	"JEFF HARRIS",
    	"Brook May",
    	"Russ Dillingham",
    	"BILL McDANIEL",
    	"PACKAGING CORPORATION",
    	"103469-001"]
    	
      file = Rails.root.join("db", "dbx.dat")
      keys = [:name, :name2, :name3, :name4, :address, :city, :state, :zip, :telephone, :fax, :email, :account_number]
      File.open(file).each do |row|
        d = {}
        matched = false
        keywords.each do |kw|
          matched = true if row.match(/#{kw}/i)
        end
        if matched
          account_no = row.chomp!.split(/\s?\|\s?/).last.to_s
          exclusions << account_no
        end
      end
    puts exclusions.to_yaml
  end
  
end