class SignupsController < ApplicationController
	before_action :set_locale

  def new
    campaign = (params[:campaign].present?) ? params[:campaign] : "#{website.brand.name}-#{Date.today.month}/#{Date.today.year}"
  	@signup = Signup.new(campaign: campaign)
    render_template action: 'new'
  end

  def create
  	@signup = Signup.new(signup_params)
  	respond_to do |format|
      @signup.brand_id = website.brand_id
      if @signup.needs_more_info?
        format.html { render action: :more_info }
      elsif @signup.save
        if @signup.campaign.present?
      	  cookies[@signup.campaign] = { value: @signup.email, expires: 1.year.from_now }
        end
        format.html { redirect_to(signup_complete_path) }
        format.xml  { render xml: @signup, status: :created, location: @signup }
      else
        format.html { render_template action: 'new' }
        format.xml  { render xml: @signup.errors, status: :unprocessable_entity }
      end
    end
  end

  def more_info
  	@signup = Signup.new(signup_params)
  end

  def complete
    render_template
  end

  private

  def signup_params
    params.require(:signup).permit(:first_name, :last_name, :email,
                                   :campaign, :company, :address,
                                   :city, :state, :zip, :country)
  end

end
