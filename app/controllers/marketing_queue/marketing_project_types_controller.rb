class MarketingQueue::MarketingProjectTypesController < MarketingQueueController
	layout "marketing_queue"
	before_filter :initialize_marketing_project_type, only: :create
	load_resource :marketing_project_type

	#
	# New MarketingProjectType always comes from an existing MarketingProject. So, load it first.
	#
	def new
		@marketing_project = MarketingProject.find(params[:marketing_project_id]) || MarketingProject.new
		@marketing_project_type.initialize_from_project(@marketing_project)
	end

	def create
    respond_to do |format|
      if @marketing_project_type.save
        format.html { redirect_to(marketing_queue_root_path, notice: 'Project template was successfully created.') }
        format.xml  { render xml: @marketing_project_type, status: :created, location: @marketing_project_type }
      else
        format.html { render action: "new" }
        format.xml  { render xml: @marketing_project_type.errors, status: :unprocessable_entity }
      end
    end
	end

	private

	def initialize_marketing_project_type
		@marketing_project_type = MarketingProjectType.new(marketing_project_type_params)
	end

	def marketing_project_type_params
		params.require(:marketing_project_type).permit!
		# (:name, :major_effort, :put_source_on_toolkit, :put_final_on_toolkit,	:keep, marketing_project_type_tasks_attributes: [:name, :position, :due_offset_number, :due_offset_unit, :creative_brief])
	end

end
