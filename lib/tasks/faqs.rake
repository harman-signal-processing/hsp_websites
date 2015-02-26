require 'csv'
namespace :faqs do

  desc "Import FAQs"
  task :original_import => :environment do
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

  desc "Import Crown FAQs"
  task :crown_import => :environment do
    crown = Brand.find("crown")

    categories_file = Rails.root.join("db", "crown-faq-categories.csv")
    faqs_file = Rails.root.join("db", "crown-faqs.csv")
    join_file = Rails.root.join("db", "crown-faq-joins.csv")

    categories = []
    faqs = []

    CSV.open(categories_file, 'r:ISO-8859-1').each do |row|
      if row[0].to_i > 0
        categories[row[0].to_i] = FaqCategory.where(name: row[2], brand_id: crown.id).first_or_create
      end
    end
    puts "There are now #{categories.length} categories"

    CSV.open(faqs_file, 'r:ISO-8859-1').each do |row|
      if row[0].to_i > 0
        faqs[row[0].to_i] = Faq.where(question: row[3], answer: row[4]).first_or_create
      end
    end
    puts "There are now #{faqs.length} FAQs"

    CSV.open(join_file, 'r:ISO-8859-1').each do |row|
      if row[0].to_i > 0 && row[1].to_i > 0
        category = categories[row[1].to_i]
        faq = faqs[row[0].to_i]

        if category && faq
          unless category.faqs.include?(faq)
            category.faqs << faq
          end
        end
      end
    end

    puts "Summary:"
    puts "-----------------------------------"
    categories.each do |c|
      if c.is_a?(FaqCategory)
        puts "  #{c.name}: #{c.faqs.length} FAQs"
      end
    end

  end

end
