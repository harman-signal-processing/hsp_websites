unless Rails.env.production?
  Delayed::Worker.delay_jobs = false
end
Delayed::Worker.default_queue_name = 'brandsites'
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
