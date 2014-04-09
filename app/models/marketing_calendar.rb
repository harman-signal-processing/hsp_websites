class MarketingCalendar < ActiveRecord::Base
  attr_accessible :name
  has_many :marketing_projects
  validates :name, presence: true, uniqueness: true
end
