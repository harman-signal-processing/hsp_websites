check process hsp_puma with pidfile /var/www/hmg/hsp_websites/shared/pids/puma.pid
    group app
    start program = "/bin/su - hmg -c 'cd /var/www/hmg/hsp_websites/current && bundle exec puma -C config/puma/production.rb'"
    stop program =  "/bin/su - hmg -c 'kill `cat /var/www/hmg/hsp_websites/shared/pids/puma.pid`'"
    if totalmem > 1800.0 MB for 5 cycles then restart
    if changed pid 2 times within 2 cycles then alert
    if changed ppid 2 times within 2 cycles then alert