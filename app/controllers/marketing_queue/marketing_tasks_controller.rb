class MarketingQueue::MarketingTasksController < MarketingQueueController
	layout "marketing_queue"
  before_filter :load_brand_if_present
  after_filter :keep_brand_in_session, only: [:show, :edit, :create, :update]
	load_resource 

  def index
    @current_marketing_tasks = MarketingTask.open
    if @brand
      @current_marketing_tasks = @current_marketing_tasks.where(brand_id: @brand.id)
    end
    respond_to do |format|
      format.html {
        if @brand
          redirect_to marketing_queue_brand_path(@brand) and return
        end
      }
      format.xml { render xml: @current_marketing_tasks.order("UPPER(name)") }
      format.json { render json: @current_marketing_tasks.order("UPPER(name)") }
      format.js
    end    
  end

  def show
  end

	def new
    if params[:marketing_project_id]
      @marketing_task.marketing_project_id = params[:marketing_project_id]
    end
    if @brand
      @marketing_task.brand_id = @brand.id
    elsif session[:brand_id]
      @marketing_task.brand_id = session[:brand_id]
    end
	end

  def edit
  end

	def create
    if !!(@marketing_task.assign_to_me)
      @marketing_task.worker_id = current_marketing_queue_user.id 
    end
    if @marketing_task.marketing_project 
      redirect_path = [:marketing_queue, @marketing_task.marketing_project]
    elsif @marketing_task.brand
      redirect_path = [:marketing_queue, @marketing_task.brand]
    else
      redirect_path = marketing_queue_root_path
    end
    respond_to do |format|
      if @marketing_task.save
        format.html { redirect_to(redirect_path, notice: 'Task was successfully created.') }
        format.xml  { render xml: @marketing_task, status: :created, location: @marketing_task }
      else
        format.html { render action: "new" }
        format.xml  { render xml: @marketing_task.errors, status: :unprocessable_entity }
      end
    end
	end

  def update
    if @marketing_task.marketing_project 
      redirect_path = [:marketing_queue, @marketing_task.marketing_project]
    elsif @marketing_task.brand
      redirect_path = [:marketing_queue, @marketing_task.brand]
    else
      redirect_path = marketing_queue_root_path
    end
    respond_to do |format|
      if @marketing_task.update_attributes(params[:marketing_task])
        format.html { redirect_to(redirect_path, notice: 'Task was successfully updated.') }
        format.xml  { render xml: @marketing_task, status: :created, location: @marketing_task }
        format.js
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @marketing_task.errors, status: :unprocessable_entity }
      end
    end 
  end

  def toggle
    @marketing_task.completed_at = @marketing_task.completed_at.blank? ? Time.now : nil
    @marketing_task.save
    render nothing: true
  end

  def destroy
    redirect_path = @marketing_task.marketing_project ? @marketing_task.marketing_project : @marketing_task.brand
    @marketing_task.destroy
    respond_to do |format|
      format.html { redirect_to [:marketing_queue, redirect_path] }
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
    if @marketing_task.brand
      session[:brand_id] = @marketing_task.brand_id
    end    
  end

end
