class Admin::PagesController < AdminController
  skip_before_action :catch_criminals # looks for SQLi in the "page" param but conflicts with this controller
  before_action :initialize_page, only: :create
  load_and_authorize_resource

  # GET /admin/pages
  # GET /admin/pages.xml
  def index
    @pages = @pages.where(brand_id: website.brand_id).order("UPPER(title)")
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @pages }
    end
  end

  # GET /admin/pages/1
  # GET /admin/pages/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @page }
    end
  end

  # GET /admin/pages/new
  # GET /admin/pages/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @page }
    end
  end

  # GET /admin/pages/1/edit
  def edit
  end

  # POST /admin/pages
  # POST /admin/pages.xml
  def create
    @page.brand = website.brand
    respond_to do |format|
      if @page.save
        format.html { redirect_to([:admin, @page], notice: 'Page was successfully created.') }
        format.xml  { render xml: @page, status: :created, location: @page }
        website.add_log(user: current_user, action: "Created page: #{@page.title}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/pages/1
  # PUT /admin/pages/1.xml
  def update
    respond_to do |format|
      if @page.update_attributes(page_params)
        format.html { redirect_to([:admin, @page], notice: 'Page was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated page: #{@page.title}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/pages/1
  # DELETE /admin/pages/1.xml
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to(admin_pages_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted page: #{@page.title}")
  end

  private

  def initialize_page
    @page = Page.new(page_params)
  end

  def page_params
    params.require(:page).permit!
  end
end
