class MarketingComment < ActiveRecord::Base
  # attr_accessible :message, :marketing_project_id, :marketing_task_id

  # belongs to either a project or a task
  belongs_to :marketing_project
  belongs_to :marketing_task

  belongs_to :user
  after_create :send_email

  def send_email
  	MarketingQueueMailer.delay.comment(self)
  end

  def participants
  	if self.user
  		([user] + self.project_or_task.participants).uniq
  	else
  		self.project_or_task.participants
  	end
  end

  def project_or_task
  	(self.marketing_project_id.present?) ? self.marketing_project : self.marketing_task
  end

  def project_or_task=(p_or_t)
  	p_or_t.is_a?(MarketingProject) ? self.marketing_project_id = p_or_t.id : self.marketing_task_id = p_or_t.id
  end

end
