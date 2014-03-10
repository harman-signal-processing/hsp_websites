class SignupsController < ApplicationController
	before_filter :set_locale

  def new
  	@signup = Signup.new(campaign: "#{website.brand.name}-#{Date.today.year}")
    if @signup.campaign.present?
      render_template action: 'new', layout: teaser_layout
    else
  	  render_template action: 'new'
    end
  end

  def create
  	@signup = Signup.new(params[:signup])
  	respond_to do |format|
      @signup.brand_id = website.brand_id
      if @signup.save
        if @signup.campaign.present?
      	  cookies[@signup.campaign] = { value: @signup.email, expires: 1.year.from_now }
          format.html { redirect_to(teaser_complete_path, notice: "Cool. You'll be the first to know!") }
        else
          format.html { redirect_to(signup_complete_path) }
        end
        format.xml  { render xml: @signup, status: :created, location: @signup }
      else
        format.html { 
          if @signup.campaign.present?
            render_template action: 'new', layout: teaser_layout 
          else
            render_template action: 'new'
          end
        }
        format.xml  { render xml: @signup.errors, status: :unprocessable_entity }
      end
    end
  end

  def complete    
  end

  private

  def teaser_layout
    File.exist?(Rails.root.join("app", "views", website.folder, "layouts", "teaser.html.erb")) ?
        "#{website.folder}/layouts/teaser" : "teaser"
  end

end
