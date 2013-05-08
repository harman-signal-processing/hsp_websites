class UsRep < ActiveRecord::Base
  attr_accessible :address, :city, :contact, :email, :fax, :name, :phone, :state, :zip
  validates :name, presence: true
  has_friendly_id :name_for_id, use_slug: true, approximate_ascii: true, max_length: 100
  has_many :us_rep_regions
  has_many :us_regions, through: :us_rep_regions

  def name_for_id
  	"#{self.name} #{self.contact}"
  end
end
