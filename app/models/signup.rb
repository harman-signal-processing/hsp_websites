class Signup < ActiveRecord::Base
  belongs_to :brand

  validates :email, presence: true, format: /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i
  validates :first_name, presence: true, if: :require_name?
  validates :last_name, presence: true, if: :require_name?
  validates :brand, presence: true

  def require_name?
    !!(self.campaign.to_s.match(/Crown-TruckTour/i))
  end
end
