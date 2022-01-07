namespace :update do

  desc "Find dealer records without a region and give it one"
  task update_dealer_regions: :environment do
    dealers_without_region = Dealer.where(region: nil)

    puts "-----#{dealers_without_region.count} missing region---------"

    dealers_without_region.order(:country).each do |dealer|
      dealer_same_country_has_region = Dealer.where("country = ? and region is not null", "#{dealer.country}").first

      if dealer_same_country_has_region.nil?
        puts "NEED REGION for country: #{dealer.country}, dealer: #{dealer.name} (id: #{dealer.id}})"
        if dealer.country == "Albania"
          region_to_use = "EUROPE"
        end
      else
        region_to_use = dealer_same_country_has_region.region
        puts "#{dealer.name} (#{dealer.id}), country: #{dealer.country}, region: #{dealer.region}, region should be: #{dealer_same_country_has_region.region}"
      end

      dealer.region = region_to_use
      dealer.save

    end  #  dealers_without_region.each do |dealer|

  end  #  task update_dealer_regions: :environment do

end  #  namespace :update do