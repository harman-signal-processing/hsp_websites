# config valid only for current version of Capistrano
lock '~> 3'

set :application, 'brandsites'
set :repo_url, 'https://github.com/harman-signal-processing/hsp_websites.git'

set :ssh_options, compression: false, keepalive: true
# Default branch is :master
#ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/#{fetch(:application)}"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/application.yml', 'config/s3.yml', 'config/analytics-api-service-project-key.json')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/redirects', 'vendor/bundle', 'public/system', 'app/views/dynamic')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :delayed_job_roles, [:background]

namespace :deploy do

#  desc 'Restart application'
#  task :restart do
#    on roles(:app), in: :sequence, wait: 5 do
#      # Your restart mechanism here, for example:
#      execute :touch, release_path.join('tmp/restart.txt')
#    end
#  end
#
#  after :publishing, :restart
#
#  after :restart, :clear_cache do
#    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
#    end
#  end

end
