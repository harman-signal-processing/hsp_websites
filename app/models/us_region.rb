class UsRegion < ApplicationRecord
  extend FriendlyId
  friendly_id :name

  has_many :us_rep_regions
  has_many :us_reps, through: :us_rep_regions
  validates :name, uniqueness: { case_sensitive: false}, presence: true
end
