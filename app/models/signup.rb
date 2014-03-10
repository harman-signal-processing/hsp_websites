class Signup < ActiveRecord::Base
  attr_accessible :campaign, :email, :name
  validates :email, presence: true, format: /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i
  validates :brand_id, presence: true
end
