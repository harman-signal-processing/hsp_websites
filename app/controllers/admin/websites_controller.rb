class Admin::WebsitesController < AdminController
  before_action :initialize_website, only: :create
  load_and_authorize_resource only: :index
  
  # GET /admin/websites
  # GET /admin/websites.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { 
        @websites = Website.all
        render xml: @websites 
      }
    end
  end

  # GET /admin/websites/1
  # GET /admin/websites/1.xml
  def show
    @this_website = Website.find(params[:id])
    @website_locale = WebsiteLocale.new(website_id: params[:id])
    authorize! :show, @this_website
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @this_website }
    end
  end

  # GET /admin/websites/new
  # GET /admin/websites/new.xml
  def new
    authorize! :create, Website
    @this_website = Website.new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @this_website }
    end
  end

  # GET /admin/websites/1/edit
  def edit
    @this_website = Website.find(params[:id])
    authorize! :edit, @this_website
  end

  # POST /admin/websites
  # POST /admin/websites.xml
  def create
    authorize! :create, Website
    @this_website = Website.new(params[:website])
    respond_to do |format|
      if @this_website.save
        format.html { redirect_to([:admin, @this_website], notice: 'Website was successfully created.') }
        format.xml  { render xml: @this_website, status: :created, location: @this_website }
        website.add_log(user: current_user, action: "Created website: #{@this_website.url}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @this_website.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/websites/1
  # PUT /admin/websites/1.xml
  def update
    @this_website = Website.find(params[:id])
    authorize! :manage, @this_website
    respond_to do |format|
      if @this_website.update_attributes(website_params)
        format.html { redirect_to([:admin, @this_website], notice: 'Website was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated website: #{@this_website.url}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @this_website.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/websites/1
  # DELETE /admin/websites/1.xml
  def destroy
    @this_website = Website.find(params[:id])
    authorize! :manage, @this_website
    @this_website.destroy
    respond_to do |format|
      format.html { redirect_to(admin_websites_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted website: #{@this_website.url}")
  end

  private

  def initialize_website
    @website = Website.new(website_params)
  end

  def website_params
    params.require(:website).permit!
  end
end
