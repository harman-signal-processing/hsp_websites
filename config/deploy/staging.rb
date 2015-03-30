#
# Dynamically choosing the git branch name no longer works.
# This is configured to deploy the currently active branch
# which has always been what I wanted anyway. However, you
# can change 'set' to 'ask' in the branch line below to
# get a prompt if needed.
#
# server-based syntax

server "10.10.23.15", user: 'hmg', roles: %w{web app db}, primary: true

# Configuration
# =============

set :application, "hsp_staging"
set :deploy_to, "/var/www/hmg/#{fetch(:application)}"

#ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, `git symbolic-ref --short HEAD`.chomp

# Keeping our special paperclip.rb initializer which lets us use production
# assets in staging environment. Comment this out if that behaviour is not needed.
set :linked_files, fetch(:linked_files, []).push('config/initializers/paperclip.rb')

namespace :deploy do

  desc 'Environment-specific assets (like test videos for staging) get linked to the rails application'
  task :link_special_assets => [:set_rails_env] do
    on roles(:web) do
      shared_asset_path = "#{fetch(:deploy_to)}/shared/assets/#{fetch(:rails_env)}"
      target_asset_path = "#{fetch(:release_path)}/app/assets/images/#{fetch(:rails_env)}"
      execute :ln, "-nfs  #{shared_asset_path} #{target_asset_path}"
    end
  end
  before 'deploy:assets:precompile', 'deploy:link_special_assets'

end

__END__

# From original capistrano 2.x file...
#

set :application, "hsp_staging"
set :deploy_to, "/var/www/hmg/#{application}"

# dynamically choose the github branch with this:
#   cap staging deploy -s branch="branchname"
#
set :branch, fetch(:branch, "master")

server "10.10.23.15", :web, :app, :db, primary: true

set :rails_env, "staging"

# before "deploy:migrate", "refresh:staging_database"
# before "deploy:restart", "refresh:staging_uploads"

namespace :deploy do
	 task :setup_config, roles: :app do
    sudo "ln -nfs /var/www/hmg/hsp_websites/current/config/nginx/staging.conf /etc/nginx/conf.d/staging.conf"
    sudo "ln -nfs /var/www/hmg/hsp_websites/current/config/nginx/security.conf /etc/nginx/security.conf"
    run "mkdir -p #{shared_path}/config"
    put File.read("./config/database.example.yml"), "#{shared_path}/config/database.yml"
    put File.read("./config/application.example.yml"), "#{shared_path}/config/application.yml"
    put File.read("./config/s3.example.yml"), "#{shared_path}/config/s3.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :link_staging_assets, roles: :web do
    run "ln -nfs /var/www/hmg/hsp_staging/shared/assets/staging #{release_path}/app/assets/images/staging"
  end
  after "deploy:assets:precompile", "deploy:link_staging_assets"

  # We have a special configuraiton for paperclip which lets us use production attachments
  # when we want to. feel free to edit the file on the server as needed throughout the
  # staging process.
  task :copy_paperclip_config, roles: :web do
    run "ln -nfs /var/www/hmg/hsp_staging/shared/config/paperclip.rb #{release_path}/config/initializers/paperclip.rb"
  end
  before "deploy:restart", "deploy:copy_paperclip_config"

end
