class UsRep < ApplicationRecord
  extend FriendlyId
  friendly_id :name_for_id

  has_many :us_rep_regions, dependent: :destroy
  has_many :us_regions, through: :us_rep_regions
  validates :name, presence: true

  def name_for_id
  	"#{self.name} #{self.contact}"
  end
end
