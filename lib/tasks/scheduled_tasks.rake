namespace :scheduled_tasks do

  # this rake task is run every 5 minutes on the servers via cron to
  # check and run any scheduled tasks
  desc "Check for and run scheduled tasks"
  task run_scheduled: :environment do

    # Let's check for any tasks that haven't run yet from the past 10 minutes
    tasks = ScheduledTask.where(status: ["", nil]).
      where("perform_at > ? && perform_at < ?", 10.minutes.ago, Time.now).
      order("perform_at ASC")
    
    tasks.each{ |scheduled_task| scheduled_task.run! }
  end
  
end
