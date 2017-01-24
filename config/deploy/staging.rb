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

set :application, "brandsites_staging"
set :deploy_to, "/var/www/#{fetch(:application)}"

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
