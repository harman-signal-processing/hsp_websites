class MarketingQueue::MarketingCommentsController < MarketingQueueController
	layout "marketing_queue"
	load_resource :marketing_project
	load_and_authorize_resource 

	def create
    @marketing_comment.user_id = current_marketing_queue_user.id 
    @marketing_comment.marketing_project_id = @marketing_project.id
    respond_to do |format|
      if @marketing_comment.save
        format.html { redirect_to([:marketing_queue, @marketing_project.brand, @marketing_project], notice: 'Your comment was successfully created.') }
        format.xml  { render xml: @marketing_comment, status: :created, location: @marketing_comment }
      else
        format.html { redirect_to([:marketing_queue, @marketing_project.brand, @marketing_project], notice: 'There was a problem creating your comment.') }
        format.xml  { render xml: @marketing_comment.errors, status: :unprocessable_entity }
      end
    end
	end

  def destroy
    @marketing_comment.destroy
    respond_to do |format|
      format.html { redirect_to([:marketing_queue, @marketing_comment.marketing_project])}
      format.js
    end
  end

end
