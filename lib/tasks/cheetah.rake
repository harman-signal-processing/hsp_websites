require 'cheetah_mail'

namespace :cheetah do 

	desc "Push updates to cheetahmail databases"
	task :push => :environment do
		per_brand_limit = 100

		Brand.all.each do |brand|
			puts "----- #{brand.name} ------"

			begin
				aid = brand.cheetahmail_aid
				sub = brand.cheetahmail_sub

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
								if ch.mailing_list_update(signup.email, sub: sub)
									signup.synced_on = Time.now
									signup.save(:validate => false)
								end
							rescue CheetahMailException
								puts "There was some cheetahmail exception"
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
