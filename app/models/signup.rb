class Signup < ActiveRecord::Base
  validates :email, presence: true, format: /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :brand_id, presence: true
end
