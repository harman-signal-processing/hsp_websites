class DistributorUser < ApplicationRecord
  belongs_to :distributor
  belongs_to :user
  validates :user, uniqueness: { scope: :distributor_id, case_sensitive: false }

end
