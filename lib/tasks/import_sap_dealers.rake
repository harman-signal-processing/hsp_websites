require 'csv'
namespace :sap do
  
  desc "Import dealers from CSV file provided by SAP"
  task :import_dealers => :environment do
    # puts "Fixing old account numbers"
    # Dealer.all.each do |dealer|
    #   dealer.format_account_number
    #   dealer.save!
    # end
    puts "Importing..."
    file = Rails.root.join("../", "../", "sap_dealers.csv")
    # keys = [:name, :name2, :name3, :name4, :address, :city, :state, :zip, :telephone, :fax, :email, :account_number]
    keys = [:sold_to, :account_number, :name, :name2, :address, :city, :state, :zip, :country, :telephone, :fax, :del_flag, :del_block, :order_block, :empty_col, :email]

    CSV.read(file).each do |row|
      next unless !!(row[0].to_s.match(/\d/))
      d = {}
      row.each_with_index { |val, i| d[keys[i]] = val }

      dealer = Dealer.find_or_initialize_by_account_number(d[:account_number])
      dealer.name      = d[:name]
      dealer.name2     = d[:name2]
      dealer.address   = d[:address]
      dealer.city      = d[:city]
      dealer.state     = d[:state]
      dealer.zip       = d[:zip]
      dealer.telephone = phormat(d[:telephone])
      dealer.fax       = phormat(d[:fax])
      dealer.email     = d[:email]

      dealer.del_flag    = d[:del_flag]
      dealer.del_block   = d[:del_block]
      dealer.order_block = d[:order_block]

      ## Test output...
      # dealer.auto_exclude
      if dealer.new_record?
        puts "     new ------#{'EXCLUDED' if dealer.exclude?}---------> #{dealer.name_and_address} "
      elsif dealer.changed?
        puts " changed ------#{'EXCLUDED' if dealer.exclude?}---------> #{dealer.name_and_address} "
      else
        puts " same --> #{dealer.name} #{'EXCLUDED' if dealer.exclude?}"
      end

      sleep(2) if dealer.new_record? || dealer.address_changed? # we had to geocode, so give Google a break for 4 seconds
      dealer.save if dealer.changed?
    end
    puts "Total dealers in database: #{Dealer.count}"
  end

  def phormat(num)
    if num.to_s.match(/^(\d{3})(\d{3})(\d{4})$/)
      "(#{$1}) #{$2}-#{$3}"
    elsif num.to_s.match(/^1(\d{3})(\d{3})(\d{4})$/)
      "1(#{$1}) #{$2}-#{$3}"
    else
      num
    end
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