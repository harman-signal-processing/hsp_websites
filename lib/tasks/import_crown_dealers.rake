class Dealer < ActiveRecord::Base
  def geocode_address
    # don't geocode during input
  end
end

require "csv"
namespace :import do

  desc "Import Crown dealers"
  task crown_dealers: :environment do
    puts "Total dealers before: #{Dealer.all.count}"
    crown = Brand.find("crown")
    BrandDealer.where(brand_id: crown.id).delete_all

    dealers_file = Rails.root.join("db", "crown-dealers.csv")

    CSV.open(dealers_file, 'r:ISO-8859-1').each do |row|
      dealer = Dealer.where(account_number: row[9]).first_or_initialize
      dealer.name ||= row[0]
      dealer.address ||= row[1]
      dealer.state ||= row[2]
      dealer.zip ||= row[3]
      dealer.city ||= row[4]
      dealer.telephone ||= row[5]
      dealer.fax ||= row[6]
      dealer.email ||= row[7]

      if dealer.save
        unless crown.dealers.include?(dealer)
          crown.dealers << dealer
        end
      end
    end

    puts "Crown dealer count: #{crown.dealers.length}"
    puts "Total dealers after: #{Dealer.all.count}"

  end

end
