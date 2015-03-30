#
# dynamically choose the github branch with this:
#   cap staging deploy -s branch="branchname"
#
# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server 'example.com', user: 'deploy', roles: %w{app db web}, my_property: :my_value
# server 'example.com', user: 'deploy', roles: %w{app web}, other_property: :other_value
# server 'db.example.com', user: 'deploy', roles: %w{db}

server "10.10.23.15", user: 'hmg', roles: %w{web app db}, primary: true


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

set :application, "hsp_staging"
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Keeping our special paperclip.rb initializer which lets us use production
# assets in staging environment. Comment this out if that behaviour is not needed.
set :linked_files, fetch(:linked_files, []).push('config/initializers/paperclip.rb')

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
namespace :deploy do

  # Environment-specific assets (like test videos for staging) get linked to
  # the rails application
  after "deploy:assets:precompile" do
    on roles(:web) do
      shared_asset_path = "#{fetch(:shared_path)}/assets/#{fetch(:rails_env)}"
      target_asset_path = "#{fetch(:release_path)}/app/assets/images/#{fetch(:rails_env)}"
      execute :ln, "-nfs  #{shared_asset_path} #{target_asset_path}"
    end
  end

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
