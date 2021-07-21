class ApplicationMailer < ActionMailer::Base
  default from: ENV['DEFAULT_SENDER']
  layout 'mailer'
end

