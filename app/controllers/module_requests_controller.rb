class ModuleRequestsController < ApplicationController
	before_action :set_locale
	
	def create
        
        if request.post?
            @module_request = AmxItgNewModuleRequest.new(module_request_params)
            if @module_request.valid?
              @module_request.contact_name = @module_request.requestor
              @module_request.contact_email = @module_request.email
            	@module_request.save

              SiteMailer.delay.amx_itg_module_request(@module_request, website.brand.amx_itg_new_module_request_recipients)

            	redirect_to support_path, notice: t('blurbs.amx_itg_module_request_thankyou') and return false
            end
        else
		      @module_request = AmxItgNewModuleRequest.new
        end  #  if request.post?
        
		render template: "#{website.folder}/support/itg_new_module_request", layout: set_layout            
	end  #  def create

  # POST /en-US/support/amx_itg_new_module_request
  # Callback after uploading a file directly to S3. Adds the temporary S3 path
  # to the form before creating new amx itg module request.
  def upload
    @direct_upload_url = params[:direct_upload_url]
    respond_to do |format|
      format.js { render template: "#{website.folder}/module_requests/upload.js", layout: false }      
    end  #  respond_to do |format|
  end  #  def upload

	private
	
  def module_request_params
    params.require(:amx_itg_new_module_request).permit!
  end	
  
end  #  class ModuleRequestsController < ApplicationController
