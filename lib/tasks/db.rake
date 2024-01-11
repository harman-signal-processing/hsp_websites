namespace :db do

	desc "Sets up the local development database with localhost websites"
	task setup_development_from_production: :environment do
	  dev_domain = ENV['DEV_DOMAIN'].present? ? ENV['DEV_DOMAIN'] : ".lvh.me"
		Brand.all.each do |brand|
			if website = brand.default_website
				website.update(url: "#{brand.to_param.gsub(/\W/, '')}#{dev_domain}")
			end
		end
	end

	desc "Sets up the staging database with '{brand}staging.digitech.com' websites"
	task setup_staging_from_production: :environment do
		if Rails.env.staging?
			Brand.all.each do |brand|
				if website = brand.default_website
					lowercase_brand = brand.to_param.gsub(/\W/, '')
					subdomain = (lowercase_brand == "digitech") ? "staging" : "#{lowercase_brand}staging"
					website.update(url: "#{subdomain}.digitech.com")
				end
			end
		else
			puts "This task should only be run in the 'staging' environment."
		end
	end

  # Here's an example of fixing something I screwed up in the production database
  # while I still have good data in the development database (assuming I refreshed
  # development pretty darn recently.)
  desc "Export news_photo_updated_at since I screwed them up in production"
  task export_setting_slide_updated_at: :environment do
    CSV.open(File.join(Rails.root, "db", "slide.csv"), "w") do |csv|
      Setting.all.each do |setting|
        csv << [setting.id, setting.slide_updated_at]
      end
    end
  end

  # And here is importing that data (see above).
  desc "Import news_photo_updated_at since I screwed them up"
  task import_setting_slide_updated_at: :environment do
    CSV.foreach(File.join(Rails.root, "db", "slide.csv")) do |csv|
      if Setting.exists?(csv[0])
        setting = Setting.find csv[0]
        if csv[1].present? && setting.slide_updated_at.to_time != csv[1].to_time
          puts "Found setting #{ setting.id }, updating date from #{ setting.slide_updated_at } to #{ csv[1] }"
          setting.update_column(:slide_updated_at, csv[1].to_time)
        end
      end
    end
  end

  desc "Export mysqldump of something along with its related stuff"
  task sqldump: :environment do
    model = ENV['MODEL']
    id = ENV['ID']
    if model.blank? or id.blank?
      puts "Must provide MODEL=Something and ID=something"
    else
      begin
        record = model.constantize.send(:find, id)
        fn = record.sqldump
        puts "Exported mysqldump script: #{fn}"
      rescue ActiveRecord::RecordNotFound
        puts " >> Oops, #{model} #{id} not found you idiot."
      end
    end
  end

  desc "Export products which have the photometric_id provided"
  task export_photometrics: :environment do
    CSV.open(File.join(Rails.root, "db", "photometric_export.csv"), "w") do |csv|
      Product.where.not(photometric_id: nil).each do |product|
        next if product.photometric_id.blank?
        csv << [product.name, product.product_status.name, "https://martin.com/en/products/#{product.to_param}", product.photometric_id]
      end
    end
  end

  desc "Export all discontinued products for a given brand"
  task export_discontinued: :environment do
    brand_name = ENV['BRAND']
    brand = Brand.find(brand_name)
    website = brand.default_website
    CSV.open(File.join(Rails.root, "db", "#{brand_name}_discontinued.csv"), "w") do |csv|
      website.discontinued_and_vintage_products.order("UPPER(products.name)").each do |product|
        csv << [product.name, product.product_status.name, "https://#{website.url}/#{I18n.default_locale}/products/#{product.to_param}"]
      end
    end
  end
end
