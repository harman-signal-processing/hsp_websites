class UsRegion < ActiveRecord::Base
  attr_accessible :name
  has_many :us_rep_regions
  has_many :us_reps, through: :us_rep_regions
  validates :name, uniqueness: true, presence: true
  has_friendly_id :name, use_slug: true, approximate_ascii: true, max_length: 100

end
