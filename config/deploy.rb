require "bundler/capistrano"
require "delayed/recipes"
require "capistrano/ext/multistage"

load "config/recipes/base"
load "config/recipes/refresh"
load "config/recipes/nginx"
load "config/recipes/monit"
load 'deploy/assets'
default_run_options[:pty] = true

# Whenever gem is not working as of 3/1/2012 try again later
# set :whenever_command, "bundle exec whenever"
# set :whenever_environment, defer { stage }
# require "whenever/capistrano"

set :stages, %w(staging production)
set :default_stage, "production"
set :user, "hmg"
set :use_sudo, false

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
    
end

#after 'deploy:update_code', 'sphinx:rebuild'
before "deploy:restart", "deploy:migrate"
after :deploy, "deploy:cleanup"
# after 'deploy:update_code', 'deploy:assets:precompile'
