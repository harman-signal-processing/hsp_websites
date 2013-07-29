class SignupsController < ApplicationController
	before_filter :set_locale

  def new
  	@signup = Signup.new(campaign: "#{website.brand.name}-#{Date.today.year}")
  	render_template action: 'new', layout: teaser_layout
  end

  def create
  	@signup = Signup.new(params[:signup])
  	respond_to do |format|
      @signup.brand_id = website.brand_id
      if @signup.save
      	cookies[@signup.campaign] = @signup.email
        format.html { redirect_to(teaser_complete_path, notice: "Cool. You'll be the first to know!") }
        format.xml  { render xml: @signup, status: :created, location: @signup }
      else
        format.html { render_template action: 'new', layout: teaser_layout }
        format.xml  { render xml: @signup.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def teaser_layout
    File.exist?(Rails.root.join("app", "views", website.folder, "layouts", "teaser.html.erb")) ?
      "#{website.folder}/layouts/teaser" : "teaser"
  end

end
