class MarketingQueue::MarketingAttachmentsController < MarketingQueueController
	layout "marketing_queue"
  before_filter :load_brand_if_present
  after_filter :keep_brand_in_session, only: [:show, :edit, :create, :update]
	load_resource

	def index
		render text: "Attachments index? Sorry, I didn't make one."
	end

	def new		
	end

  # Starts the download of the attachment. We land here first in order to avoid the
  # CDN so we don't cache these files publicly.
  def show
    send_file @marketing_attachment.marketing_file.path, content_type: @marketing_attachment.marketing_file_content_type
  end

	def create
    if @marketing_attachment.marketing_project 
      redirect_path = [:marketing_queue, @marketing_attachment.marketing_project]
    else
      redirect_path = marketing_queue_root_path
    end
    respond_to do |format|
      if @marketing_attachment.save
        format.html { redirect_to(redirect_path, notice: 'Attachment was successfully created.') }
        format.xml  { render xml: @marketing_attachment, status: :created, location: @marketing_attachment }
      else
        format.html { render action: "new" }
        format.xml  { render xml: @marketing_attachment.errors, status: :unprocessable_entity }
      end
    end
	end

  def destroy
    @marketing_attachment.destroy
    respond_to do |format|
      format.html { redirect_to [:marketing_queue, @marketing_attachment.marketing_project]}
      format.js
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
    if @marketing_attachment.marketing_project.brand
      session[:brand_id] = @marketing_attachment.marketing_project.brand_id
    end    
  end
end
