# A MarketingProject is a container for things like a new product launch,
# promotion, new website, etc.
#
# It belongs to a Brand and a MarketingProjectType which serves as a template
# to generate appropriate tasks when creating the project.
#
# One User is the owner for a given project. This will usually be a market manager.
# The owner will provide event dates (where applicable), target costs, etc.
#
# TODO: When the project type results in a new product, then the project needs
#       to be tied to a Product somehow.
#
#
class MarketingProject < ActiveRecord::Base
  # attr_accessible :brand_id, :estimated_cost, :due_on, :event_end_on, :event_start_on, :marketing_project_type_id, :name, :targets, :targets_progress, :tasks_follow_project, :user_id, :marketing_calendar_id
  attr_accessor :tasks_follow_project
  has_event_calendar start_at_field: 'event_start_on', end_at_field: 'event_end_on'
  belongs_to :brand 
  belongs_to :user 
  belongs_to :marketing_project_type 
  belongs_to :marketing_calendar
  has_many :marketing_tasks, dependent: :destroy
  has_many :marketing_attachments, -> { order("created_at DESC") }, dependent: :destroy
  has_many :marketing_comments, dependent: :destroy
  validates :name, presence: :true
  validates :brand_id, presence: :true
  validates :user_id, presence: true
  validates :due_on, presence: true
  before_create :setup_from_template
  after_update :adjust_tasks

  def setup_from_template
  	if marketing_project_type 
  		marketing_project_type.marketing_project_type_tasks.each do |mptt|
  			self.marketing_tasks << mptt.generate_task(marketing_project: self)
  		end
  	end
  end

  # If the project's due date changed, move the tasks' due date
  def adjust_tasks
    if self.due_on_changed? && tasks_follow_project.to_i > 0
      delta = self.due_on.to_date - self.due_on_was.to_date
      incomplete_marketing_tasks.each do |t|
        t.update_attributes due_on: t.due_on.advance(days: delta.to_i)
      end
    end
  end

  def self.for_report(brand_ids, marketing_calendar_id=false, start_on=false, end_on=false, no_sort=false)
    m = where(brand_id: brand_ids)
    m = m.where(marketing_calendar_id: marketing_calendar_id) unless marketing_calendar_id.blank?
    if start_on && !end_on
      m = m.where("event_end_on >= ? OR event_start_on >= ?", start_on.to_date, start_on.to_date)
    elsif end_on && !start_on
      m = m.where("event_start_on <= ? OR event_end_on <= ? ", end_on.to_date, end_on.to_date)
    elsif start_on && end_on
      m = m.where("(event_end_on <= ? AND event_end_on >= ?) OR (event_start_on <= ? AND event_start_on >= ?)", end_on.to_date, start_on.to_date, end_on.to_date, start_on.to_date)
    end

    m = m.order("event_start_on, event_end_on") unless no_sort
    m
  end

  def self.open
    where("id IN (?) OR event_end_on >= ? OR due_on >= ?", MarketingTask.open_project_ids, 1.day.ago, 1.day.ago).order("due_on ASC")
  end

  def self.open_with_tasks
    where("id IN (?)", MarketingTask.open_project_ids).order("due_on ASC")
  end

  def self.closed
    where("id NOT IN (?)", MarketingTask.open_project_ids).where("event_end_on < ? OR due_on < ?", 1.day.ago, 1.day.ago)
  end

  def self.ending
    open_with_tasks.order("due_on ASC, event_end_on ASC")
  end

  def self.newest
    order("created_at DESC")
  end

  # Collects projects to display on the finance overview
  #
  def self.six_month_overview
    where("due_on >= ? OR event_end_on >= ?", 1.month.ago, 1.month.ago).where("due_on <= ? OR event_end_on <= ?", 6.months.from_now, 6.months.from_now)
  end

  def percent_complete
    if completed_marketing_tasks.count > 0
      ( completed_marketing_tasks.count.to_f / marketing_tasks.count.to_f ) * 100.0
    else
      0
    end
  end

  def completed_marketing_tasks
    @completed_marketing_tasks ||= marketing_tasks.where("completed_at IS NOT NULL AND completed_at <= ?", Date.tomorrow).order("completed_at DESC")
  end

  def incomplete_marketing_tasks
    @incomplete_marketing_tasks ||= marketing_tasks.where("completed_at IS NULL OR completed_at > ?", Date.tomorrow).order("priority ASC, due_on ASC")
  end

  def incomplete_marketing_tasks_for_staff_meeting
    @incomplete_marketing_tasks_for_staff_meeting ||= marketing_tasks.where("completed_at IS NULL OR completed_at > ?", Date.tomorrow).where("due_on <= ?", 5.months.from_now).order("priority ASC, due_on ASC")
  end

  def participants
    ([user] + marketing_tasks.where("worker_id > 0").map{|t| t.worker} + marketing_comments.map{|c| c.user}).uniq
  end

  def duration_in_days
    if event_end_on.present? && event_start_on.present?
      (event_end_on - event_start_on).to_i
    else
      1
    end
  end
  
  def starts_x_days_after(some_date)
    start_on = (event_start_on.present?) ? event_start_on : due_on
    x = (start_on - some_date.to_date).to_i
    (x < 0) ? 0 : x
  end

end
