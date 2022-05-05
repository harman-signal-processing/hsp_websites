namespace :refresh do
	# These capistrano tasks are super handy in setting up a development environment which
	# mimics the current state of the production site. Sometimes it is helpful to have real
	# data to develop around. The tasks are broken down into these steps:
	#
	# cap production refresh:development_database (copies the production db to your local dev environemnt)
	# cap production refresh:development_uploads (compresses and copies file uploads from production)
	# cap production refresh:development (performs both tasks)
	#
  # For staging:
  #
  # cap staging refresh:staging_database
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

  desc "Replace local database and uploads from production"
  task :development do
    invoke 'refresh:development_database'
    invoke 'refresh:development_uploads'
  end

	desc "Refresh the staging database and uploads from production"
	task :staging do
		invoke 'refresh:staging_database'
		invoke 'refresh:staging_uploads'
	end

  # Pass in keep_db to keep the database dump received from the server on your
  # local machine:
  #
  #   cap production refresh:development_database keep_db=true
  #
  desc "Replace the local development database with the contents of the production database"
  task :development_database do
    set :timestamp, Time.now.to_i

    on roles(:db) do
      @timestamp = fetch(:timestamp)

      within shared_path do
        @db = YAML::load(ERB.new(IO.read(File.join("config", "database.yml"))).result)['production']
      end

      @filename = "#{@db['database']}_#{@timestamp}.sql"
      folder = "db_backup"
      execute :mkdir, "-p", folder

      within folder do
        execute :mysqldump, "--add-drop-table --add-locks --create-options --disable-keys --lock-tables --quick --column-statistics=0 --set-charset --complete-insert -u #{@db['username']} --password=#{@db['password']} -h #{@db['host']} --port=#{@db['port']} #{@db['database']} > #{@filename}"
        curr = capture(:pwd)
        download! "#{curr}/#{@filename}", "./#{@filename}"
        execute :rm, @filename
      end
    end

    run_locally do
      with rails_env: :development do
        @timestamp = fetch(:timestamp)

        db = YAML::load(ERB.new(IO.read(File.join(File.dirname(__FILE__), "../../../config", "database.yml"))).result)
        prd_db = db['production']
        dev_db = db['development']
        filename = "#{prd_db['database']}_#{@timestamp}.sql"

        rake 'db:environment:set RAILS_ENV=development'
        rake 'db:drop'
        rake 'db:create'

        execute :mysql, "-u #{dev_db['username']} #{dev_db['database']} < ./#{filename}"
        unless ENV['keep_db'] == "true"
          execute :rm, filename
        end

        puts "Local development database refreshed from production, catching up missing migrations:"
        rake 'db:migrate'
        puts "Setting up localhost sites"
        rake 'db:setup_development_from_production'
        rake 'db:test:prepare'
      end
    end
  end

  desc "Replace contents of public/system from remote server"
  task :development_uploads do
    on roles(:web) do |host|
      set :upload_host, host
      set :upload_user, host.user
    end

    run_locally do
      execute :rsync, "-avz #{fetch(:upload_user)}@#{fetch(:upload_host)}:#{ shared_path }/public/system ./public/"
    end
  end

  desc "Replace the remote staging database with the contents of the production database"
  task :staging_database do
    set :timestamp, Time.now.to_i

    on roles(:db) do

      with rails_env: :staging do
        within shared_path do
          @db = YAML::load(ERB.new(IO.read(File.join("config", "database.yml"))).result)
        end

        within release_path do
          rake 'db:environment:set RAILS_ENV=staging'
          rake 'db:drop'
          rake 'db:create'

          execute :mysqldump, "--opt -u #{@db['production']['username']} --password=#{@db['production']['password']} -h #{@db['production']['host']} --port=#{@db['production']['port']} #{@db['production']['database']} | mysql -u #{@db['staging']['username']} --password=#{@db['staging']['password']} #{@db['staging']['database']}"

          rake 'db:migrate'
          puts "Setting up staging sites"
          rake 'db:setup_staging_from_production'
        end
      end

    end
  end

	desc "Copies ALL uploaded assets from production to staging"
	task :staging_uploads do
		puts "Staging environment mounts the production uploads, so no content syncing is possible or needed."
	end

end

__END__
# From original capistrano 2.x task...
namespace :refresh do

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
  	# Rails 4.1 should setup test database automatically
  	# puts "Setting up test database"
  	# puts `bundle exec rake RAILS_ENV=development db:test:prepare`
	end

	desc "Backup the production database and install it on top of the remote staging db"
	task :staging_database, roles: :db, primary: true do
		backup_database
  	run "cd #{deploy_to}/current && bundle exec rake RAILS_ENV=staging db:drop"
  	run "cd #{deploy_to}/current && bundle exec rake RAILS_ENV=staging db:create"
  	run "mysql -u #{@db['staging']['username']} --password=#{@db['staging']['password']} #{@db['staging']['database']} < #{@file}"
  	run "rm #{@file}"
  	puts "Staging database refreshed from production, catching up missing migrations:"
  	run "cd #{deploy_to}/current && bundle exec rake RAILS_ENV=staging db:migrate"
  	puts "Setting up staging sites"
  	run "cd #{deploy_to}/current && bundle exec rake RAILS_ENV=staging db:setup_staging_from_production"
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


	def backup_database
		setup_file "hspwww_production_#{Time.now.to_i}.sql"
  	@db = YAML::load(ERB.new(IO.read(File.join(File.dirname(__FILE__), '../database.yml'))).result)
  	run "mysqldump -u #{@db['production']['username']} -h #{@db['production']['host']} --port=#{@db['production']['port']} --password=#{@db['production']['password']} #{@db['production']['database']} > #{@file}"
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
