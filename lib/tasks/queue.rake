namespace :queue do

  # Sends a daily digest to queue users. Only scheduled to run on weekdays, so
  # the task searches back 3 days if task is run on a Monday.
 	#
  desc "Sends a daily digest to queue users"
  task send_digests: :environment do
    range = (Date.today.monday?) ? 3.days.ago : 1.day.ago

  	new_projects     = MarketingProject.where("created_at >= ?", range)
 		open_projects    = MarketingProject.open.order("due_on DESC") - new_projects
		unassigned_tasks = MarketingTask.unassigned

  	User.marketing_staff.each do |user|
  		my_tasks    = user.incomplete_marketing_tasks
  		my_projects = MarketingProject.open.where(user_id: user.id)

  		if my_tasks.count > 0 || my_projects.count > 0 || user.role?(:queue_admin)
  			MarketingQueueMailer.daily_digest(user, {
  				my_projects: my_projects, 
  				my_tasks: my_tasks, 
  				new_projects: new_projects, 
  				open_projects: open_projects, 
  				unassigned_tasks: unassigned_tasks
  			}).deliver # Don't use delayed job here since these collections aren't serialized
  		end
  	end
  end

end