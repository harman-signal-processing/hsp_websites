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
      subject: "Daily marketing queue summary"
  end

  def comment(marketing_comment)
    @marketing_comment = marketing_comment
    @marketing_project = marketing_comment.marketing_project
    participants = @marketing_project.participants

    mail to: participants.map{|u| u.email},
      subject: "Comment: #{@marketing_project.name}"
  end
end
