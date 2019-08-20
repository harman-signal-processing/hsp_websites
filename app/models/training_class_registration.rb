class TrainingClassRegistration < ApplicationRecord
  belongs_to :training_class

  validates :email, presence: true
  after_create :notify

  def notify
    if registration_recipients.length > 0
      SiteMailer.delay.training_class_registration_notice(self)
    end
  end

  def registration_recipients
    rr = []
    rr << training_class.training_course.send_registrations_to
    if training_class.instructor.present? && training_class.instructor.email.present?
      rr << training_class.instructor.email
    end
    rr.flatten
    rr
  end
end
