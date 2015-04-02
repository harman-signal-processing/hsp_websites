class DistributorUser < ActiveRecord::Base
  belongs_to :distributor
  belongs_to :user
  validates :user_id, presence: true, uniqueness: { scope: :distributor_id }
  validates :distributor_id, presence: true

end
