class MarketingComment < ActiveRecord::Base
  attr_accessible :message
  belongs_to :marketing_project
  belongs_to :user
  # after_create :send_email

  def send_email
  	MarketingQueueMailer.delay.comment(self)
  end

end
