class DistributorUser < ApplicationRecord
  belongs_to :distributor
  belongs_to :user
  validates :user, presence: true, uniqueness: { scope: :distributor_id, case_sensitive: false }
  validates :distributor, presence: true

end
