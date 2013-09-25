class MarketingQueue::MarketingProjectTypesController < MarketingQueueController
	layout "marketing_queue"
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

end
