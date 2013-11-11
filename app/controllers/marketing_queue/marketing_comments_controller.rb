class MarketingQueue::MarketingCommentsController < MarketingQueueController
	layout "marketing_queue"
  before_filter :load_project_or_task
	load_and_authorize_resource 

	def create
    @marketing_comment.user_id = current_marketing_queue_user.id 
    @marketing_comment.project_or_task = @project_or_task
    respond_to do |format|
      if @marketing_comment.save
        format.html { redirect_to([:marketing_queue, @project_or_task.brand, @project_or_task], notice: 'Your comment was successfully created.') }
        format.xml  { render xml: @marketing_comment, status: :created, location: @marketing_comment }
      else
        format.html { redirect_to([:marketing_queue, @project_or_task.brand, @project_or_task], notice: 'There was a problem creating your comment.') }
        format.xml  { render xml: @marketing_comment.errors, status: :unprocessable_entity }
      end
    end
	end

  def destroy
    @marketing_comment.destroy
    respond_to do |format|
      format.html { redirect_to([:marketing_queue, @marketing_comment.project_or_task])}
      format.js
    end
  end

private

  def load_project_or_task
    if params[:marketing_project_id]
      @project_or_task = MarketingProject.find(params[:marketing_project_id])
    else
      @project_or_task = MarketingTask.find(params[:marketing_task_id])
    end
  end

end
