class SoftwareReport < ApplicationRecord
  belongs_to :software
  has_many :software_report_subscriptions, dependent: :destroy
  has_many :users, through: :software_report_subscriptions

  # Don't "delay" mailer because we store the current
  # count for next month's report after sending it
  def send_monthly_report
    if software_report_subscriptions.size > 0
      SiteMailer.with(software_report: self).monthly_software_report.deliver_now
    end
    update(previous_count: software.download_count, previous_count_on: Date.today)
  end

  def recipients
    users.pluck(:email).uniq.compact
  end

  def new_downloads
    software.download_count.to_i - previous_count.to_i
  end
end
