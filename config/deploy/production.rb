
set :application, "hsp_websites"
set :deploy_to, "/var/www/hmg/#{application}"

# The "web" role is tied to asset compiling. Unfortunately, removing the role
# from some of the hosts which don't need to compile assets (because we're using
# the asset_host directive) causes "asset not compiled" errors.

server "10.10.23.86", :web, :app
server "10.10.23.15", :web, :app #, :db, primary: true
server "rackspace1",  :web, :app, :db, primary: true

set :rails_env, "production"

before "deploy:restart", "thinking_sphinx:configure" 

# after "deploy:restart", "delayed_job:restart" # restart these manually to avoid deployment overloads
#after "deploy:restart", "deploy:ping"
after "deploy:start", "delayed_job:start"
after "deploy:stop", "delayed_job:stop"

namespace :deploy do
  desc "Hit the site to really spin it up"
  task :ping, :roles => :web do
    run "wget -nd --delete-after http://www.digitech.com/en-US/"
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs /var/www/hmg/hsp_websites/current/config/nginx/a_catchall.conf /etc/nginx/conf.d/a_catchall.conf"
    sudo "ln -nfs /var/www/hmg/hsp_websites/current/config/nginx/archimedia.conf /etc/nginx/conf.d/archimedia.conf"
    sudo "ln -nfs /var/www/hmg/hsp_websites/current/config/nginx/assets.conf /etc/nginx/conf.d/assets.conf"
    sudo "ln -nfs /var/www/hmg/hsp_websites/current/config/nginx/bss.conf /etc/nginx/conf.d/bss.conf"
    sudo "ln -nfs /var/www/hmg/hsp_websites/current/config/nginx/crown.conf /etc/nginx/conf.d/crown.conf"
    sudo "ln -nfs /var/www/hmg/hsp_websites/current/config/nginx/dbx.conf /etc/nginx/conf.d/dbx.conf"
    sudo "ln -nfs /var/www/hmg/hsp_websites/current/config/nginx/digitech.conf /etc/nginx/conf.d/digitech.conf"
    sudo "ln -nfs /var/www/hmg/hsp_websites/current/config/nginx/dod.conf /etc/nginx/conf.d/dod.conf"
    sudo "ln -nfs /var/www/hmg/hsp_websites/current/config/nginx/hardwire.conf /etc/nginx/conf.d/hardwire.conf"
    sudo "ln -nfs /var/www/hmg/hsp_websites/current/config/nginx/idx.conf /etc/nginx/conf.d/idx.conf"
    sudo "ln -nfs /var/www/hmg/hsp_websites/current/config/nginx/jbl_commercial.conf /etc/nginx/conf.d/jbl_commercial.conf"
    sudo "ln -nfs /var/www/hmg/hsp_websites/current/config/nginx/lexicon.conf /etc/nginx/conf.d/lexicon.conf"
    sudo "ln -nfs /var/www/hmg/hsp_websites/current/config/nginx/queue.conf /etc/nginx/conf.d/queue.conf"
    # sudo "ln -nfs /var/www/hmg/hsp_websites/current/config/nginx/testsites.conf /etc/nginx/conf.d/testsites.conf"
    sudo "ln -nfs /var/www/hmg/hsp_websites/current/config/nginx/toolkits.conf /etc/nginx/conf.d/toolkits.conf"
    sudo "ln -nfs /var/www/hmg/hsp_websites/current/config/nginx/vocalist.conf /etc/nginx/conf.d/vocalist.conf"
    sudo "ln -nfs /var/www/hmg/hsp_websites/current/config/nginx/security.conf /etc/nginx/security.conf"
    sudo "ln -nfs /var/www/hmg/hsp_websites/current/config/nginx/common.conf /etc/nginx/common.conf"
    # run "mkdir -p #{shared_path}/config"
    # put File.read("./config/database.example.yml"), "#{shared_path}/config/database.yml"
    # put File.read("./config/application.example.yml"), "#{shared_path}/config/application.yml"
    # put File.read("./config/s3.example.yml"), "#{shared_path}/config/s3.yml"
    # puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :asset_sync_config, roles: :web do
    run "ln -nfs /var/www/hmg/hsp_websites/current/config/asset_sync.yml #{release_path}/config/asset_sync.yml"
    run "ln -nfs /var/www/hmg/hsp_websites/current/config/asset_sync.rb #{release_path}/config/initializers/asset_sync.rb"
  end
  #This didn't work so well..., but let's try it again.
  before "deploy:assets:precompile", "deploy:asset_sync_config"
end


