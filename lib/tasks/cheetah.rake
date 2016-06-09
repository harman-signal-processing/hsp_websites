require 'cheetah_mail'

namespace :cheetah do

  desc "Push updates to cheetahmail databases"
  task :push => :environment do
    per_brand_limit = 100

    Brand.all.each do |brand|
      puts "----- #{brand.name} ------"

      begin
        aid = brand.try(:cheetahmail_aid)
        sub = brand.try(:cheetahmail_sub)
        event_id = brand.try(:cheetahmail_event_id)

        if aid.present? && sub.present?
          puts "(aid: #{aid}, sub: #{sub})"

          ch = CheetahMail::CheetahMail.new({
            :host      => 'ebm.cheetahmail.com',
            :username  => ENV['CHEETAHMAIL_USERNAME'],
            :password  => ENV['CHEETAHMAIL_PASSWORD'],
            :aid       => aid,
            :messenger => CheetahMail::SynchronousMessenger
          })

          brand.new_signups[0,per_brand_limit].each do |signup|
            if signup.valid?
              puts "Signing up #{signup.email}..."
              begin
                subscription_params = {sub: sub}
                subscription_params[:e] = event_id if !!event_id
                if ch.mailing_list_update(signup.email, subscription_params)
                  signup.synced_on = Time.now
                  signup.save(:validate => false)
                end
              rescue CheetahMailException
                puts "There was some cheetahmail exception"
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
            end
          end
        end # if brand has cheetah settings
      rescue
        puts "....something went wrong"
      end
    end # brand loop

  end # push task

end
