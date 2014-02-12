namespace :refresh do

	# These capistrano tasks are super handy in setting up a development environment which
	# mimics the current state of the production site. Sometimes it is helpful to have real
	# data to develop around. The tasks are broken down into these steps:
	#
	# cap refresh:development_database (copies the production db to your local dev environemnt)
	# cap refresh:development_uploads (compresses and copies file uploads from production)
	# cap refresh:development (performs both tasks)
	#
	# In order to work, though, the LOCAL database.yml file needs to have credentials for
	# the production system and whichever target environment (dev or staging).
	#
	# As of 12/2013, the asset sync no longer works. This is because the files are moved
	# to Amazon S3 instead of on an internal server. This can be fixed, however, the plan
	# is to migrate away from S3 in favor of rackspace cloud files. So, I'll address the
	# issue then instead.
	#
	# Note: the "development_uploads" task will take a long time since there are lots of
	# files (images, movies, pdfs, etc.) which have been uploaded via the web admin interfaces.
	#

	desc "Refresh the development database and uploads from production"
	task :development do
		development_database
		development_uploads
	end

	desc "Refresh the staging database and uploads from production"
	task :staging do
		staging_database
		staging_uploads
	end

	desc "Backup the production database and install it on top of the local dev db"
	task :development_database, roles: :db, primary: true do
		backup_database
  	get_and_remove_file
  	puts `bundle exec rake RAILS_ENV=development db:drop`
  	puts `bundle exec rake RAILS_ENV=development db:create`
  	password_command = ""
  	if @db['development']['password'] && !@db['development']['password'].blank?
  		password_command = "--password=#{@db['development']['password']}"
  	end
  	puts `mysql -u #{@db['development']['username']} #{password_command} #{@db['development']['database']} < ./#{@filename}`
  	puts `rm ./#{@filename}`
  	puts "Local development database refreshed from production, catching up missing migrations:"
  	puts `bundle exec rake RAILS_ENV=development db:migrate`
  	puts "Setting up localhost sites"
  	puts `bundle exec rake RAILS_ENV=development db:setup_development_from_production`
	end

	desc "Backup the production database and install it on top of the remote staging db"
	task :staging_database, roles: :db, primary: true do
		backup_database
  	run "cd #{deploy_to}/current && /usr/bin/env rake RAILS_ENV=staging db:drop"
  	run "cd #{deploy_to}/current && /usr/bin/env rake RAILS_ENV=staging db:create"
  	run "mysql -u #{@db['staging']['username']} --password=#{@db['staging']['password']} #{@db['staging']['database']} < #{@file}"
  	run "rm #{@file}"
  	puts "Staging database refreshed from production, catching up missing migrations:"
  	run "cd #{deploy_to}/current && /usr/bin/env rake RAILS_ENV=staging db:migrate"
  	puts "Setting up staging sites"
  	run "cd #{deploy_to}/current && /usr/bin/env rake RAILS_ENV=staging db:setup_staging_from_production"
	end
	
	desc "Syncs the latest uploaded assets from production to development"
	task :development_uploads, roles: :web do
	  `rsync -avz "hmg@10.10.23.86:/var/www/hmg/hsp_websites/shared/system" "./public/"`
  end

	desc "Copies ALL uploaded assets from production to development"
	task :development_uploads_tarball, roles: :web do
		setup_file("hsp_assets.tar.gz")
		run "cd /var/www/hmg/hsp_websites/shared && tar -czf #{@file} ./system"
		get_and_remove_file
		puts `cd public && tar -zxf ../#{@filename} && rm ../#{@filename}`
	end
	
	desc "Copies ALL uploaded assets from production to staging"
	task :staging_uploads, roles: :web do
		# run "rsync -azv hmg@10.10.23.86:/var/www/hmg/hsp_websites/shared/system /var/www/hmg/hsp_staging/shared/"
		puts "Staging environment mounts the production uploads, so no content syncing is possible or needed."
	end

	def backup_database
		setup_file "hspwww_production_#{Time.now.to_i}.sql"
  	@db = YAML::load(ERB.new(IO.read(File.join(File.dirname(__FILE__), '../database.yml'))).result)
  	run "mysqldump -u #{@db['production']['username']} -h #{@db['production']['host']} --password=#{@db['production']['password']} #{@db['production']['database']} > #{@file}"
	end

	def setup_file(filename)
		@filename = filename
		@folder = "/home/hmg/db_backup"
		run "mkdir -p #{@folder}"
		@file = "#{@folder}/#{@filename}"		
	end

	def get_and_remove_file
		get @file, "./#{@filename}", via: :scp
		run "rm #{@file}"		
	end

end