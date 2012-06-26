namespace :service do
  
  desc "Import service centers"
  task :import => :environment do
    brand = Brand.find_by_name("dbx")
    File.open(Rails.root.join("db", "proservicecenters.txt")).each do |row|
      fields = row.split("\t")
      ServiceCenter.create(
        :name => fields[0],
        :name2 => fields[1],
        :address => fields[2],
        # :address2 => fields[3],
        # :address3 => fields[4],
        :city => fields[5],
        :state => fields[6],
        :zip => fields[7],
        :telephone => fields[8],
        :fax => fields[9],
        :email => fields[10],
        :website => fields[11],
        :brand_id => brand.id
      )
    end
  end
  
end