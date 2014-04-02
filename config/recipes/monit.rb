namespace :monit do
  desc "Install Monit"
  task :install do
    run "#{sudo} yum -y install monit"
  end
  after "deploy:install", "monit:install"

  desc "Setup all Monit configuration"
  task :setup do
    monit_config "monitconf", "/etc/monit.conf"
    nginx
    # mysql
    # passenger
    # syntax
    reload
  end
  after "deploy:setup", "monit:setup"
  
  task(:nginx, roles: :web) { monit_config "nginx" }
  # task(:mysql, roles: :db) { monit_config "mysql" }
  task(:passenger, roles: :web) { monit_config "passenger" }

  %w[start stop restart syntax reload].each do |command|
    desc "Run Monit #{command} script"
    task command do
      run "#{sudo} service monit #{command}"
    end
  end
end

def monit_config(name, destination = nil)
  destination ||= "/etc/monit.d/#{name}.conf"
  template "monit/#{name}.erb", "/tmp/monit_#{name}"
  run "#{sudo} mv /tmp/monit_#{name} #{destination}"
  run "#{sudo} chown root #{destination}"
  run "#{sudo} chmod 600 #{destination}"
end