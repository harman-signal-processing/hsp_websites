
set :application, "hsp_staging"
set :deploy_to, "/var/www/hmg/#{application}"

# dynamically choose the github branch with this:
#   cap staging deploy -s branch="branchname"
#
set :branch, fetch(:branch, "master")

server "10.10.23.15", :web, :app, :db, primary: true
#server "10.10.23.86", :web, :app, :db

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
  before "deploy:assets:precompile", "deploy:link_staging_assets"
end
