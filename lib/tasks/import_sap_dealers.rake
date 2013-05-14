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

      dealer = Dealer.where(account_number: d[:account_number]).first_or_initialize
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

  desc "Update dealers/brands relationships"
  task :update_brand_dealers => :environment do 
    Brand.all.each do |brand|
      file = Rails.root.join("../", "../", "#{brand.friendly_id}.csv")
      if File.exist?(file)
        puts "Reading #{brand.name} data..."
        puts "  starting with #{brand.dealers.count} dealers"
        CSV.read(file).each do |row|
          if dealer = Dealer.where(account_number: row[1].to_s).first
            dealer.add_to_brand!(brand) unless dealer.exclude?
          end
        end

        # Remove any dealers who haven't bought this brand in over a year. Since the
        # BI reports span 1 year, all the valid once should have been touched in the
        # previous loop. To be safe, keep 1 month worth of deadbeats at a time.
        #
        brand.brand_dealers.where("updated_at < ?", 1.months.ago).each do |bd|
          if bd.dealer.parent && bd.dealer.parent.updated_at > 1.month.ago
            d.touch
          else
            d.destroy
          end
        end
        brand.reload
        puts "  ending with #{brand.dealers.count} dealers"
      end
    end

    # Clean up remaining stragglers
    BrandDealer.where("updated_at < ?", 1.months.ago).each do |bd|
      if bd.dealer.parent && bd.dealer.parent.updated_at > 1.month.ago
        d.touch
      else
        d.destroy
      end
    end

    # This will utilize another rake task to create user accounts for the
    # the new dealers:
    Rake::Task['toolkit:create_dealer_users'].invoke
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