class Signup < ApplicationRecord
  belongs_to :brand

  validates :email, presence: true, email: true
  validates :first_name, presence: true, if: :require_name?
  validates :last_name, presence: true, if: :require_name?

  def require_name?
    !!(self.campaign.to_s.match(/Crown-TruckTour/i))
  end

  def needs_more_info?
    !!(email.blank? || first_name.blank? || last_name.blank?)
  end
end
