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
  attr_accessible :brand_id, :estimated_cost, :due_on, :event_end_on, :event_start_on, :marketing_project_type_id, :name, :targets, :targets_progress
  has_event_calendar start_at_field: 'event_start_on', end_at_field: 'event_end_on'
  belongs_to :brand 
  belongs_to :user 
  belongs_to :marketing_project_type 
  has_many :marketing_tasks, dependent: :destroy, order: :position
  has_many :marketing_attachments, dependent: :destroy, order: "created_at DESC"
  has_many :marketing_comments, dependent: :destroy
  validates :name, presence: :true
  validates :brand_id, presence: :true
  validates :user_id, presence: true
  validates :due_on, presence: true #, if: :needs_due_date?
  before_create :setup_from_template

  def setup_from_template
  	if marketing_project_type 
  		marketing_project_type.marketing_project_type_tasks.each do |mptt|
  			self.marketing_tasks << mptt.generate_task(marketing_project: self)
  		end
  	end
  end

  # Always needs a due date
  # def needs_due_date?
  # 	self.marketing_project_type_id.present? && self.marketing_project_type.marketing_project_type_tasks.count > 0
  # end

  def self.open
    project_ids = MarketingTask.open.where("marketing_project_id > 0").pluck(:marketing_project_id).uniq
    where("id IN (?) OR event_end_on >= ? OR due_on >= ?", project_ids, 1.day.ago, 1.day.ago)
  end

  def self.closed
    project_ids = MarketingTask.open.where("marketing_project_id > 0").pluck(:marketing_project_id).uniq
    where("id NOT IN (?)", project_ids).where("event_end_on < ? OR due_on < ?", 1.day.ago, 1.day.ago)
  end

  def self.ending
    open.order("due_on DESC, event_end_on DESC")
  end

  def self.newest
    order("created_at ASC")
  end

  # TODO: Need a better way to compute project percent complete
  def percent_complete
    if completed_marketing_tasks.count > 0
      ( completed_marketing_tasks.count.to_f / marketing_tasks.count.to_f ) * 100.0
    else
      0
    end
  end

  def completed_marketing_tasks
    @completed_marketing_tasks ||= marketing_tasks.where("completed_at IS NOT NULL AND completed_at <= ?", Date.tomorrow)
  end

  def incomplete_marketing_tasks
    @incomplete_marketing_tasks ||= marketing_tasks.where("completed_at IS NULL OR completed_at > ?", Date.tomorrow)
  end

  def participants
    ([user] + marketing_tasks.where("worker_id > 0").map{|t| t.worker}).uniq
  end

end
