class MarketingQueue::BrandsController < MarketingQueueController
	layout "marketing_queue"
	after_filter :keep_brand_in_session, only: [:show, :edit, :create, :update]
	load_resource 

	def index
	end

	def show
		# Set up the calendar
		@start_on = params[:start_on] || 7.days.ago.beginning_of_month
    @start_on = @start_on.to_date
		@end_on = params[:end_on] || @start_on.advance(months: 5).end_of_month
    @end_on = @end_on.to_date

		@current_marketing_projects = MarketingProject.open.where(brand_id: @brand.id)
		@completed_marketing_projects = MarketingProject.closed.where(brand_id: @brand.id).order("due_on DESC, event_end_on DESC").limit(10)
		@incomplete_marketing_tasks = MarketingTask.open.where(brand_id: @brand.id).where("marketing_project_id IS NULL or marketing_project_id = ''").order("due_on ASC")
		@completed_marketing_tasks =  @brand.marketing_tasks.where("marketing_project_id IS NULL or marketing_project_id = ''").where("completed_at IS NOT NULL").order("completed_at DESC").limit(5)
    respond_to do |format|
      format.html 
      format.xml { render xml: @current_marketing_projects }
      format.json { render json: @current_marketing_projects.order("UPPER(name)") }
    end
	end

	private

	def keep_brand_in_session
    if @brand
      session[:brand_id] = @brand.id
    end    
  end
end
