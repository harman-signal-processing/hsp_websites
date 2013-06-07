set :repository,  "http://svn.hmg.ad.harman.com/repos/hmgwww/trunk/hsp_websites"
set :scm, :subversion
set :deploy_via, :export
set :application, "hsp_websites"
set :deploy_to, "/var/www/hmg/#{application}"

server "10.10.23.86", :web, :app
server "10.10.23.15", :web, :app, :db, primary: true

set :rails_env, "production"

after "deploy:restart", "deploy:ping"

namespace :deploy do
  desc "Hit the site to really spin it up"
  task :ping, :roles => :web do
    run "wget -nd --delete-after http://10.10.23.87/en-US/"
  end
end

after "deploy:stop", "delayed_job:stop"
after "deploy:start", "delayed_job:start"
after "deploy:restart", "delayed_job:restart"

# before "deploy:restart", "thinking_sphinx:rebuild" # takes too long
