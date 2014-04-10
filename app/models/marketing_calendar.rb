class MarketingCalendar < ActiveRecord::Base
  attr_accessible :name
  has_many :marketing_projects
  validates :name, presence: true, uniqueness: true

  def event_strips_for_month(shown_month, options={})
  	mp = self.marketing_projects
  	mp = mp.where(brand_id: options[:brand_id]) if options[:brand_id]
   	mp.event_strips_for_month(shown_month)
  end

end
