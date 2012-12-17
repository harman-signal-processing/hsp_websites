namespace :nginx do
  desc "Copy config files for NGINX and then restart it"
  task :reconfigure, roles: :web do
    configure
    restart
  end
  
  desc "Copy config files for NGINX"
  task :configure, roles: :web do
    %w[a_catchall bss dbx digitech dod hardwire idx jbl_commercial lexicon testsites vocalist toolkits].each do |site_name|
      run "#{sudo} ln -nfs #{current_path}/config/nginx/#{site_name}.conf /etc/nginx/conf.d/#{site_name}.conf"
    end
  end
  
  desc "Restart NGINX"
  task :restart, roles: :web do
    run "#{sudo} service nginx restart"
  end
end