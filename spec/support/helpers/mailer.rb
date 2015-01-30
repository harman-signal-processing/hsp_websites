module Features
  module Mailer

    def last_email
      ActionMailer::Base.deliveries.last
    end

  end
end
