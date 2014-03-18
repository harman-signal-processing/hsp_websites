# A MarketingProjectType is a template for new MarketingProjects. This allows us
# to create a default set of tasks for new projects. The idea is all new products
# share a similar set of tasks each time. All promotions usually have the same
# kind of tasks.
#
# An instance of MarketingProjectType has any number of MarketingProjectTypeTasks 
# which are not actual tasks. These are used as template tasks.
#
class MarketingProjectType < ActiveRecord::Base
  attr_accessible :major_effort, :name, :put_source_on_toolkit, :put_final_on_toolkit, :marketing_project_type_tasks_attributes
  has_many :marketing_project_type_tasks, order: :position
  has_many :marketing_projects
  validates :name, presence: true, uniqueness: true
  accepts_nested_attributes_for :marketing_project_type_tasks, allow_destroy: true, reject_if: :skip_tasks #proc { |a| !(a[:keep?]) }

  #
  # Lists types that can be created as new projects (all of them for now--
  # at some point we may limit by some criteria)
	#
  def self.creatable
  	order(:name)
  end

  #
  # Provide a MarketingProject to initialize this MarketingProjectType
  # with its tasks, name, etc.
  #
  def initialize_from_project(marketing_project)
  	self.name ||= "#{marketing_project.name} Template"
    new_task_attributes = []
    marketing_project.marketing_tasks.each do |task|
      due_offset = task.calculate_due_offset
      new_task_attributes << { name: task.name, 
        keep: true,
        due_offset_number: due_offset[:number],
        due_offset_unit: due_offset[:unit] }
    end
    self.marketing_project_type_tasks.build( new_task_attributes )
    3.times { self.marketing_project_type_tasks.build }
  end

  def skip_tasks(attributes)
    attributes['keep'].to_i < 1
  end

end
