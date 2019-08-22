class TrainingClassRegistration < ApplicationRecord
  belongs_to :training_class

  validates :email, presence: true
  after_create :notify

  def notify
    if registration_recipients.length > 0
      SiteMailer.delay.training_class_registration_notice(self)
    end
  end

  def training_course
    @training_course ||= training_class.training_course
  end

  def default_recipient
    begin
      training_course.brand.support_email
    rescue
      "support@harman.com"
    end
  end

  def registration_recipients
    rr = []

    if training_course.send_registrations_to.present?
      rr << training_course.send_registrations_to
    end

    if training_class.instructor.present? && training_class.instructor.email.present?
      rr << training_class.instructor.email
    end
    rr.flatten

    rr << default_recipient if rr.length == 0
    rr
  end

end
