class MarketingQueueMailer < ActionMailer::Base
  default from: "harmanpro_marketing@harman.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.marketing_queue_mailer.daily_digest.subject
  #
  def daily_digest(user, options={})
    @user             = user
    @my_tasks         = options[:my_tasks]
    @my_projects      = options[:my_projects]
    @new_projects     = options[:new_projects]
    @open_projects    = options[:open_projects]
    @unassigned_tasks = options[:unassigned_tasks]

    mail to: @user.email,
      subject: "[QQ] Daily marketing queue summary"
  end

  def comment(marketing_comment)
    @marketing_comment = marketing_comment
    @marketing_project = marketing_comment.marketing_project
    participants = @marketing_project.participants

    mail to: participants.map{|u| u.email},
      subject: "[QQ] Comment: #{@marketing_project.name}"
  end

  def task_assigned(marketing_task)
    @marketing_task = marketing_task
    @worker = marketing_task.worker

    mail to: @worker.email, subject: "[QQ] Task Assigned"
  end

  def new_task(marketing_task)
    @marketing_task = marketing_task
    mail to: 'jason.kunz@harman.com', subject: "[QQ] New Unassigned Task"
  end
  
end
