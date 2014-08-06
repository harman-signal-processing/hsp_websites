class MarketingQueue::MarketingProjectsController < MarketingQueueController
	layout "marketing_queue"
  before_filter :load_brand_if_present
  before_filter :initialize_marketing_project, only: :create
  after_filter :keep_brand_in_session, only: [:show, :edit, :create, :update]
  skip_before_filter :authenticate_marketing_queue_user!, only: :overview
	load_resource

  def index
    @marketing_projects = []
    @marketing_tasks = []
    if @brand
      @marketing_projects = MarketingProject.open.where(brand_id: @brand.id)
    elsif params[:q] # search...
      @q = MarketingProject.ransack(params[:q])
      @marketing_projects = @q.result
      @q2 = MarketingTask.ransack(params[:q])
      @marketing_tasks = @q2.result
    end
    respond_to do |format|
      format.html {
        if @brand
          redirect_to marketing_queue_brand_path(@brand) and return
        elsif !(params[:q]) || (@marketing_projects.count == 0 && @marketing_tasks.count == 0)
          render text: "No results found.", layout: true and return
        end
      }
      format.xml { render xml: @marketing_projects.order("UPPER(name)") }
      format.json { render json: @marketing_projects.order("UPPER(name)") }
      format.js
    end    
  end

  # Shows an overview of all projects for finance dept.
  def overview
    @marketing_projects = MarketingProject.six_month_overview.where("estimated_cost > 0").order("brand_id")
  end

  def show
    @marketing_task = MarketingTask.new(marketing_project_id: @marketing_project.id, brand_id: @marketing_project.brand_id, due_on: @marketing_project.due_on)
    @marketing_attachment = MarketingAttachment.new(marketing_project_id: @marketing_project.id)
    @marketing_comment = MarketingComment.new(marketing_project_id: @marketing_project.id)
  end

	def new
    if params[:marketing_project_type_id]
      @marketing_project.marketing_project_type_id = params[:marketing_project_type_id]
    end
    if @brand
      @marketing_project.brand_id = @brand.id
    elsif session[:brand_id]
      @marketing_project.brand_id = session[:brand_id]
    end
	end

	def create
    @marketing_project.user_id ||= current_marketing_queue_user.id
    respond_to do |format|
      if @marketing_project.save
        format.html { redirect_to([:marketing_queue, @marketing_project], notice: 'Project was successfully created.') }
        format.xml  { render xml: @marketing_project, status: :created, location: @marketing_project }
      else
        format.html { render action: "new" }
        format.xml  { render xml: @marketing_project.errors, status: :unprocessable_entity }
      end
    end
	end

  def edit
    @marketing_project.tasks_follow_project = true
  end

  def update
    respond_to do |format|
      if @marketing_project.update_attributes(marketing_project_params)
        format.html { redirect_to([:marketing_queue, @marketing_project], notice: 'Project was successfully updated.') }
        format.xml  { render xml: @marketing_project, status: :created, location: @marketing_project }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @marketing_project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @marketing_project.destroy
    respond_to do |format|
      format.html { redirect_to([:marketing_queue, @marketing_project.brand], notice: 'The project was deleted.') }
    end
  end

  private

  def load_brand_if_present
    if params[:brand_id]
      @brand = Brand.find params[:brand_id]
      session[:brand_id] = params[:brand_id]
    end
  end

  def keep_brand_in_session
    if @marketing_project.brand
      session[:brand_id] = @marketing_project.brand_id
    end    
  end

  def initialize_marketing_project
    @marketing_project = MarketingProject.new(marketing_project_params)
  end

  def marketing_project_params
    params.require(:marketing_project).permit(:name, :brand_id, :user_id, :marketing_project_type_id, :event_start_on, :event_end_on, :targets, :targets_progress, :estimated_cost, :put_source_on_toolkit, :put_final_on_toolkit, :due_on, :marketing_calendar_id)
  end

end
