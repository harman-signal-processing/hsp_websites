class Admin::AmxPartnerInterestFormController < AdminController
	load_and_authorize_resource class: "AmxPartnerInterestForm"
	respond_to :json, :html
	
	def index
	    respond_to do |format|
	      format.html {
			@partner_interest_requests = AmxPartnerInterestForm.all.order("created_at DESC")
	      }

	      format.json  {
			render json: AmxPartnerInterestForm.all.order("created_at DESC").as_json()
	      }
	    end	 #  respond_to do |format|

		# @partner_interest_requests = AmxPartnerInterestForm.all
	end  #  def index
	

end  #  class Admin::AmxPartnerInterestFormController < AdminController
