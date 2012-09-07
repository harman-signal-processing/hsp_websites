# set :scm, :none
# set :deploy_via, :copy
# set :repository, "." # deploys from the current local content--whatever that is--long time if lots of assets

set :scm, :subversion
set :deploy_via, :export
set :repository, "http://svn.hmg.ad.harman.com/repos/hmgwww/trunk/hsp_websites"

set :application, "hsp_staging"
set :deploy_to, "/var/www/hmg/#{application}"

server "10.10.23.15", :web, :app, :db, primary: true

set :rails_env, "staging"

# before "deploy:migrate", "refresh:staging_database"
# before "deploy:restart", "refresh:staging_uploads"
