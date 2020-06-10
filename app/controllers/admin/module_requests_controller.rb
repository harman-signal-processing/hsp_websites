class Admin::ModuleRequestsController < AdminController
	load_and_authorize_resource class: "AmxItgNewModuleRequest"
	respond_to :json, :html
	
	def index
	    respond_to do |format|
	      format.html {
			@module_requests = AmxItgNewModuleRequest.all.order("created_at DESC")
	      }

	      format.json  {
			render json: AmxItgNewModuleRequest.all.order("created_at DESC").as_json(:except => [:direct_upload_url, :updated_at, :processed], :methods => :attachment_download_url)
	      }
	    end	 #  respond_to do |format|

		# @module_requests = AmxItgNewModuleRequest.all
	end  #  def index
	

end  #  class Admin::ModuleRequestsController < AdminController
