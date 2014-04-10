require "bundler/capistrano"
require "delayed/recipes"
require "capistrano/ext/multistage"
require 'thinking_sphinx/capistrano'

load "config/recipes/base"
load "config/recipes/refresh"
load "config/recipes/nginx"
load "config/recipes/monit"
load 'deploy/assets'
default_run_options[:pty] = true

set :scm, :git
set :deploy_via, :remote_cache
set :repository, "https://github.com/harman-signal-processing/hsp_websites"

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
    # run "#{try_sudo} service memcached restart"
  end

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml"
    run "ln -nfs #{shared_path}/config/s3.yml #{release_path}/config/s3.yml"
  end
  after "deploy:update_code", "deploy:symlink_config"
  before "deploy:assets:precompile", "deploy:symlink_config"
    
end

before "deploy:restart", "deploy:migrate"
after :deploy, "deploy:cleanup"
# after 'deploy:update_code', 'deploy:assets:precompile'


# a capistrano task to list tasks by role.
namespace :list do
  desc "list tasks by role"
  task :by_role do
    tasks = top.task_list(:all)

    set(:verbose, false) unless exists?(:verbose)
    unless verbose
      tasks = tasks.reject { |t| t.description.empty? || t.description =~ /^\[internal\]/ }
    end

    role_tasks = {}
    tasks.each do |task|
      role_tasks[task.options[:roles]] ||= []
      role_tasks[task.options[:roles]] << task
    end

    longest = tasks.map { |task| task.fully_qualified_name.length }.max
    max_length = longest + 10

    role_tasks.keys.sort{|a,b| a.to_s <=> b.to_s}.each do |role|
      puts role
      role_tasks[role].each do |task|
          puts "\t%-#{longest}s # %s" % [task.fully_qualified_name, (task.desc.nil?) ? "" : task.desc[0..100].gsub(/\n/,' ').squeeze(' ')+"..."]
      end
      puts "\n"
    end

  end
end
