# A MarketingTask usually belongs to a MarketingProject as part of a 
# larger effort.
#
class MarketingTask < ActiveRecord::Base
  attr_accessible :brand_id, :completed_at, :due_on, :marketing_project_id, :name, :assign_to_me, :worker_id, :man_hours, :priority
  attr_accessor :assign_to_me
  belongs_to :brand 
  belongs_to :marketing_project
  belongs_to :requestor, class_name: "User", foreign_key: :requestor_id
  belongs_to :worker, class_name: "User", foreign_key: :worker_id
  belongs_to :currently_with, class_name: "User", foreign_key: :currently_with_id
  has_many :marketing_attachments, dependent: :destroy, order: "created_at DESC"
  has_many :marketing_comments, dependent: :destroy
  acts_as_list scope: :marketing_project_id
  validates :name, presence: :true
  validates :due_on, presence: :true
  validates :brand_id, presence: :true
  before_save :auto_switch_currently_with
  after_save :notify_worker
  after_create :notify_admin

  #
  # When creating a related MarketingProjectTypeTask, this is called to figure
  # out the due date offsets (unit and type (weeks, days, months))
  #
  def calculate_due_offset
  	if self.marketing_project.due_on && self.due_on && self.marketing_project.due_on.to_date > self.due_on.to_date
  		difference_in_days = (self.marketing_project.due_on.to_date - self.due_on.to_date).to_i
  		if difference_in_days % 30 == 0
  			{ number: (difference_in_days / 30), unit: 'months' }
  		elsif difference_in_days % 31 == 0
  			{ number: (difference_in_days / 31), unit: 'months' }
  		elsif difference_in_days % 7 == 0
  			{ number: (difference_in_days / 7), unit: 'weeks' }
  		else
  			{ number: difference_in_days, unit: 'days' }
  		end
  	else
  		{ number: 1, unit: 'days' }	
  	end
  end

  def self.open
    where("completed_at IS NULL or completed_at = ''")
  end

  def self.open_project_ids
    open.where("marketing_project_id > 0").pluck(:marketing_project_id).uniq
  end

  def self.unassigned
    where("worker_id IS NULL or worker_id < 1")
  end

  def late?
    completed_at.blank? && due_on < Date.today
  end

  def switch_currently_with
    case currently_with_id
    when requestor_id
      self.currently_with_id = self.worker_id
    when worker_id
      self.currently_with_id = self.requestor_id
    else
      self.currently_with_id = self.worker_id
    end
  end

  def auto_switch_currently_with
    if worker_id_changed? && worker_id.present?
      switch_currently_with
    end    
  end

  def notify_worker
    if worker_id_changed? && worker_id != requestor_id && worker_id.present?
      MarketingQueueMailer.delay.task_assigned(self)
    end
  end

  def notify_admin
    if worker_id.blank?
      MarketingQueueMailer.delay.new_task(self)
    end
  end

  def participants
    commenters = []
    commenters << requestor if self.requestor_id.present?
    commenters << worker if self.worker_id.present?
    (commenters + marketing_comments.map{|c| c.user}).uniq
  end

end
