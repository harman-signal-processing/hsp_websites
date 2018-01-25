class Dealer < ActiveRecord::Base
  def geocode_address
    # don't geocode during input
  end
end

require "csv"
namespace :import do

  desc "Import Martin dealers"
  task martin_dealers: :environment do
    puts "Total dealers before: #{Dealer.all.count}"
    martin = Brand.find("martin")
    BrandDealer.where(brand_id: martin.id).delete_all

    dealers_file = Rails.root.join("db", "martin-dealers.csv")

    CSV.open(dealers_file, 'r:ISO-8859-1', headers: true).each do |row|
      dealer = Dealer.where(name: row[1], city: row[6]).first_or_initialize
      dealer.address ||= "#{row[2]} #{row[3]} #{row[4]}"
      dealer.state ||= row[7]
      dealer.zip ||= row[5]
      dealer.country ||= row[8]
      dealer.telephone ||= row[9]
      dealer.fax ||= row[10]
      dealer.email ||= row[11]
      dealer.website ||= row[12]
      dealer.resale ||= row[13]
      dealer.rental ||= row[14]
      dealer.rush ||= row[15]
      dealer.installation ||= row[16]
      dealer.service ||= row[19]
      dealer.represented_in_country ||= row[20]
      dealer.lat ||= row[21]
      dealer.lng ||= row[22]
      dealer.google_map_place_id ||= row[23]
      dealer.account_number ||= "Martin-#{row[0]}"

      if dealer.save
        unless martin.dealers.include?(dealer)
          martin.dealers << dealer
        end
      end
    end

    puts "Martin dealer count: #{martin.dealers.length}"
    puts "Total dealers after: #{Dealer.all.count}"

  end

end
