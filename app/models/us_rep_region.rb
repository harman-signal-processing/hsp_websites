class UsRepRegion < ActiveRecord::Base
  validates :brand, presence: true
  validates :us_region, presence: true
  validates :us_rep, presence: true

  belongs_to :us_rep
  belongs_to :us_region
  belongs_to :brand

  accepts_nested_attributes_for :us_region, reject_if: :all_blank
end
