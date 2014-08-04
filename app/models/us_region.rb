class UsRegion < ActiveRecord::Base
  # attr_accessible :name
  has_many :us_rep_regions
  has_many :us_reps, through: :us_rep_regions
  validates :name, uniqueness: true, presence: true
  extend FriendlyId
  friendly_id :name

end
