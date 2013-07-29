class Signup < ActiveRecord::Base
  attr_accessible :campaign, :email, :name
  validates :email, presence: true
  validates :brand_id, presence: true
end
