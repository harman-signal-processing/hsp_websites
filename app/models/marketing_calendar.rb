class MarketingCalendar < ActiveRecord::Base
  has_many :marketing_projects
  has_many :marketing_tasks

  validates :name, presence: true, uniqueness: true

  def event_strips_for_month(shown_month, options={})
  	strips(shown_month, :marketing_projects, options) + strips(shown_month, :marketing_tasks, options)
  end

  def strips(shown_month, relation, options={})
  	events = eval("self.#{relation.to_s}")
  	events = events.where(brand_id: options[:brand_id]) if options[:brand_id]
    events.event_strips_for_month(shown_month)
  end

end
