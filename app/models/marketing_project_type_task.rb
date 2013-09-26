# A MarketingProjectTypeTask belongs to a MarketingProjectType which is used
# as a template when a new MarketingProject is created. 
#
# TODO: Probably, a "new product" type of project needs to have special rules
#       developed to link and create a Product record for the public site.
#
class MarketingProjectTypeTask < ActiveRecord::Base
  attr_accessible :name, :position, :marketing_project_type_id, :due_offset_number, :due_offset_unit, :keep
  attr_accessor :keep
  belongs_to :marketing_project_type
  acts_as_list scope: :marketing_project_type_id
  validates :name, presence: :true, uniqueness: { scope: :marketing_project_type_id }

  #
  # Initializes a new MarketingTask for the provided MarketingProject
  # based on settings from the current MarketingProjectTypeTask. Calculates
  # the due date for the new task.
  #
  def generate_task(options)
  	marketing_project = options[:marketing_project] || MarketingProject.new(brand_id: 1)

  	due_on = 2.days.from_now # default
  	if marketing_project.due_on.present?
  		if self.due_offset_number.present? && self.due_offset_unit.present?
  			due_on = eval("marketing_project.due_on.advance(" + self.due_offset_unit + ": - self.due_offset_number)")
  			due_on = marketing_project.due_on if due_on < Date.today
  		end
  	end

  	MarketingTask.new(
  		due_on: due_on,
  		name: self.name,
      brand_id: marketing_project.brand_id
  	)
  end

end
