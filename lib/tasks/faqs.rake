require 'csv'
namespace :faqs do
  
  desc "Import FAQs"
  task :import => :environment do
    CSV.open(Rails.root.join("db", "faqs.csv"), 'r').each do |row|
      # puts row
      products = row[1].split(",")
      question = row[2]
      answer   = row[3]
      products.each do |product_id|
        begin
          product = Product.find(product_id)
          Faq.create(:product => product, :question => question, :answer => answer)
          puts "Created a FAQ for #{product.name}"
        rescue
          puts " ****Could not find product #{product_id}"
        end
      end
    end
  end
  
end