class Signup < ActiveRecord::Base
  belongs_to :brand

  validates :email, presence: true, email: true
  validates :first_name, presence: true, if: :require_name?
  validates :last_name, presence: true, if: :require_name?
  validates :brand, presence: true

  def require_name?
    !!(self.campaign.to_s.match(/Crown-TruckTour/i))
  end
end
