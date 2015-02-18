class ServiceCenter < ActiveRecord::Base
  def geocode_address
    # don't geocode during input
  end
end

namespace :service do

  desc "Import service centers"
  task :import => :environment do
    brand = Brand.find("crown")
    errors = []
    File.open(Rails.root.join("db", "crown-service-centers.txt")).each do |row|
      begin
        fields = row.split("\t")
        puts "Creating Service Center: #{fields[2]}"
        ServiceCenter.where(
          :account_number => fields[0].gsub(/\"/, '').gsub(/\s*$/, ''),
          :name => fields[2].gsub(/\"/, '').gsub(/\s*$/, ''),
          :name2 => fields[3].gsub(/\"/, '').gsub(/\s*$/, ''),
          :address => fields[4,2].join(" ").gsub(/\"/, '').gsub(/\s*$/, ''),
          :city => fields[6].gsub(/\"/, '').gsub(/\s*$/, ''),
          :state => fields[7].gsub(/\"/, '').gsub(/\s*$/, ''),
          :zip => fields[8].gsub(/\"/, '').gsub(/\s*$/, ''),
          :telephone => fields[9].gsub(/\"/, '').gsub(/\s*$/, ''),
          #:fax => fields[9],
          :email => fields[10].gsub(/\"/, '').gsub(/\s*$/, ''),
          :website => fields[12].gsub(/\"/, '').chomp.gsub(/\s*$/, ''),
          :brand_id => brand.id
        ).first_or_create
      rescue
        errors << row
      end
    end
    if errors.length > 0
      puts "#{errors.length} Error(s):"
      errors.each {|e| puts e }
    end
  end

end
