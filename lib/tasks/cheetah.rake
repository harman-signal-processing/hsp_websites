require 'cheetah_mail'

namespace :cheetah do 

	desc "Push updates to cheetahmail databases"
	task :push => :environment do

		ch = CheetahMail::CheetahMail.new({
		  :host      => 'ebm.cheetahmail.com',
		  :username  => ENV['CHEETAHMAIL_USERNAME'],
		  :password  => ENV['CHEETAHMAIL_PASSWORD'],
		  :messenger => CheetahMail::SynchronousMessenger
		})	

		Brand.all.each do |brand|
			begin
				aid = brand.settings.where(name: "cheetahmail_aid").value
				sub = brand.settings.where(name: "cheetahmail_sub").value

				if aid && sub
					brand.new_signups.each do |signup|
						ch.mailing_list_update(signup.email, sub: sub, aid: aid) if signup.valid?
						signup.synced_on = Time.now
						signup.save(:validate => false)
					end
				end # if brand has cheetah settings
			rescue
				# Probably didn't have aid/sub...move on
			end
		end # brand loop

	end # push task

end
