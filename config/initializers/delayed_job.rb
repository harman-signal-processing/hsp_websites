unless Rails.env.production?
  Delayed::Worker.delay_jobs = false
end