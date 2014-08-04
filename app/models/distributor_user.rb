class DistributorUser < ActiveRecord::Base
  # attr_accessible :distributor_id, :user_id
  belongs_to :distributor 
  belongs_to :user 
  validates :user_id, presence: true, uniqueness: { scope: :distributor_id }
  validates :distributor_id, presence: true
  
end
