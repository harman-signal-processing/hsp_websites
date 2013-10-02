# A MarketingTask usually belongs to a MarketingProject as part of a 
# larger effort.
#
class MarketingTask < ActiveRecord::Base
  attr_accessible :brand_id, :completed_at, :due_on, :marketing_project_id, :name, :assign_to_me, :worker_id
  attr_accessor :assign_to_me
  belongs_to :brand 
  belongs_to :marketing_project
  belongs_to :requestor, class_name: "User", foreign_key: :requestor_id
  belongs_to :worker, class_name: "User", foreign_key: :worker_id
  acts_as_list scope: :marketing_project_id
  validates :name, presence: :true
  validates :due_on, presence: :true
  validates :brand_id, presence: :true

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

  def self.unassigned
    where("worker_id IS NULL or worker_id < 1")
  end

  def late?
    completed_at.blank? && due_on < Date.today
  end

end
