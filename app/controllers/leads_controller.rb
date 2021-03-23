class LeadsController < ApplicationController

  def new
    @lead = Lead.new
  end

  def create
    @lead = Lead.new(lead_params)
    @lead.source = website.url
    if verify_recaptcha(model: @lead, secret_key: website.recaptcha_private_key) && @lead.save
      redirect_to support_path, notice: "Thanks for contacting us. We will be in touch soon."
    else
      render action: 'new'
    end
  end

  private

  def lead_params
    params.require(:lead).permit(
      :name,
      :company,
      :email,
      :phone,
      :city,
      :state,
      :country,
      :project_description,
      :subscribe
    )
  end

end

