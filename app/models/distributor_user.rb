class DistributorUser < ApplicationRecord
  belongs_to :distributor
  belongs_to :user
  validates :user, presence: true, uniqueness: { scope: :distributor_id }
  validates :distributor, presence: true

end
