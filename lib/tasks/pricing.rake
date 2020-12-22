namespace :pricing do

  desc "2021 pricing updates"
  task :update_2021 => :environment do

    pricing_file = ENV["PRICING_UPDATE"]

    CSV.open(pricing_file, 'r:ISO-8859-1').each do |row|
      if row[7].to_s.present? && Product.exists?(row[7])
        if product = Product.find(row[7])
          puts "Updating #{ product.name }"
          product.update({
            sap_sku: row[1],
            msrp: row[4],
            street_price: row[5]
          })
        end
      end
    end

  end

end
