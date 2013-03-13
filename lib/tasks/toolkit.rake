namespace :toolkit do
  
  # This should be a one-time use task, populating the users
 	# for the HSP toolkit
 	#
  desc "Create toolkit user accounts for dealers"
  task :create_dealer_users => :environment do
  	Dealer.all.each do |dealer|
  		dealer.format_account_number
  		dealer.save! # (fix the old account number formatting)
 			unless dealer.parent.users.count > 0 || dealer.parent.email.blank?
 				user = User.find_or_initialize_by_email(dealer.parent.email)
 				user.name ||= dealer.parent.name
 				user.dealer = true
 				user.account_number = dealer.parent.account_number
 				if user.new_record?
 					user.password = "toolkit"
 					user.password_confirmation = "toolkit"
 				end
				user.skip_confirmation!
				if user.save
 					user.confirm!
	  			puts "added --> #{user.name}"
	  		else
	  			puts "problem adding --> #{user.name}"
	  		end
  		end
  	end
  end

  # Another one-time use task, populating the toolkit with
  # distributor users
  #
  desc "Create toolkit user accounts for distributors"
  task :create_distributor_users => :environment do
  	Distributor.all.each do |distributor|
  		if distributor.detail.to_s.match(/mailto\:([^\'\"\\]*)/i)
  			user = User.find_or_initialize_by_email($1)
  			user.name ||= distributor.name 
  			user.distributor = true
  			if user.new_record?
	  			user.password = "toolkit"
	  			user.password_confirmation = "toolkit"
	  		end
	  		user.skip_confirmation!
	  		if user.save
	  			user.confirm!
	  			puts "added --> #{user.name}"
	  		else
	  			puts "problem adding --> #{user.inspect}"
	  		end
  		else
  			puts "skipped without email: #{distributor.name}"
  		end
  	end
  end

end