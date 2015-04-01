# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server 'example.com', user: 'deploy', roles: %w{app db web}, my_property: :my_value
# server 'example.com', user: 'deploy', roles: %w{app web}, other_property: :other_value
# server 'db.example.com', user: 'deploy', roles: %w{db}

server "rackspace1",  user: 'hmg', roles: %w{web app db background}, primary: true
server "10.10.23.86", user: 'hmg', roles: %w{web app}
server "10.10.23.15", user: 'hmg', roles: %w{web app}


# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}



# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.

# Adding asset_sync configs to linked_files
#set :linked_files, fetch(:linked_files, []).push('config/asset_sync.yml', 'config/initializers/asset_sync.rb')
before "deploy:restart", "thinking_sphinx:configure"

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }


__END__

# From original 2.x capistrano file...
#
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
    sudo "ln -nfs /var/www/hmg/hsp_websites/current/config/nginx/audio-architect.conf /etc/nginx/conf.d/audio-architect.conf"
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
end


