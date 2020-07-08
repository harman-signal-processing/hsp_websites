require 'acoustic'
require 'oauth2'

namespace :acoustic do

  desc "Push updates to acoustic databases"
  task :push => :environment do
    per_brand_limit = 100

    client = OAuth2::Client.new(ENV['ACOUSTIC_CLIENT_ID'],
                                ENV['ACOUSTIC_CLIENT_SECRET'],
                                site: "#{ENV['ACOUSTIC_API_URL']}/oauth/token")
    access_token = OAuth2::AccessToken.from_hash(client, refresh_token: ENV['ACOUSTIC_REFRESH_TOKEN']).refresh!

    @client = Acoustic.new(access_token: access_token.token, url: ENV['ACOUSTIC_API_URL'])

    Brand.all.each do |brand|
      puts "----- #{brand.name} ------"

      begin
        dbid = brand.try(:acoustic_database_id)
        list_id = brand.try(:acoustic_contact_list_id)

        if dbid.present? && list_id.present?
          puts "(dbid: #{dbid}, sub: #{list_id})"

          brand.new_signups[0,per_brand_limit].each do |signup|
            #puts "Trying #{ signup.email }..."
            if signup.valid?
              puts "Signing up #{signup.email}..."
              begin
                user_params = { email: signup.email, :"BR_#{brand.name}" => true }
                user_params["0001_First_Name".to_sym] = signup.first_name if signup.respond_to?(:first_name)
                user_params["0002_Last_Name".to_sym] = signup.last_name if signup.respond_to?(:last_name)
                user_params["0011_Country"] = signup.country if signup.respond_to?(:country)
                user_params["Opt In Details".to_sym] = "Submitted via #{brand.default_website.url} "
                if signup.campaign.present?
                  user_params["Opt In Details".to_sym] += "(campaign: #{signup.campaign.to_s}) "
                elsif signup.is_a?(WarrantyRegistration)
                  user_params["Opt In Details".to_sym] += "(via warranty registration for: #{signup.product.name}) "
                end
                @client.add_recipient(user_params, dbid, [list_id])
                signup.update_column(:synced_on, Date.today)
              rescue
                puts "There was some acoustic exception"
                if signup.is_a?(WarrantyRegistration)
                  signup.subscribe = false
                  signup.save(:validate => false)
                else
                  signup.delete
                end
              end
            elsif signup.is_a?(Signup)
              puts "Deleting invalid entry: #{signup.email}"
              signup.delete
            elsif signup.is_a?(WarrantyRegistration)
              puts "  unsubscribing invalid entry: #{signup.email}"
              signup.update_column(:subscribe, false)
            end
          end
        end # if brand has acoustic settings
      rescue
        puts "....something went wrong"
      end
    end # brand loop

  end # push task

end
