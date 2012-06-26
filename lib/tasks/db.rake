namespace :db do

	desc "Sets up the local development database with localhost websites"
	task setup_development_from_production: :environment do
		Brand.all.each do |brand|
			if website = brand.default_website
				website.update_attributes(url: "#{brand.to_param.gsub(/\W/, '')}.lvh.me")
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
					website.update_attributes(url: "#{subdomain}.digitech.com")
				end
			end
		else
			puts "This task should only be run in the 'staging' environment."
		end
	end

end