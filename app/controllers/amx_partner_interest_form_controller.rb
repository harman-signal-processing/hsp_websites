class AmxPartnerInterestFormController < ApplicationController
	before_action :set_locale

	def create
		if request.post?
			@partner_interest_request = AmxPartnerInterestForm.new(partner_interest_params)
			if @partner_interest_request.valid?
				 @partner_interest_request.save
         SiteMailer.delay.amx_partner_interest_form(@partner_interest_request, website.brand.amx_partner_interest_form_recipients)
         redirect_to amx_partners_home_path, notice: t('blurbs.amx_partner_interest_form_thankyou') and return false
			end  #  if @partner_interest_request.valid?

		else
			@partner_interest_request = AmxPartnerInterestForm.new
		end  #  if request.post?

		render template: "#{website.folder}/partners/form", layout: set_layout
	end  # def create

	private

  def partner_interest_params
    params.require(:amx_partner_interest_form).permit!
  end
end  # class AmxPartnerInterestFormController < ApplicationController
