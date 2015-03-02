require 'csv'
namespace :products do

  desc "Import Crown FAQs"
  task :crown_import => :environment do
    crown = Brand.find("crown")
    discontinued = ProductStatus.where(name: "Discontinued").first

    products_file = Rails.root.join("db", "crown-discontinued-products.csv")

    CSV.open(products_file, 'r:ISO-8859-1').each do |row|
      if row[0].to_s.present?
        p = Product.create!(name: row[0].to_s, brand: crown, product_status_id: discontinued.id)
        puts "Created: #{p.name}"
      end
    end

  end

end
