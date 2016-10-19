class Admin::GetStartedPagesController < AdminController
  before_filter :initialize_get_started_page, only: :create
  load_and_authorize_resource

  # GET /admin/get_started_pages
  # GET /admin/get_started_pages.xml
  def index
    @get_started_pages = @get_started_pages.where(brand_id: website.brand_id).order("UPPER(name)")
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @get_started_pages }
    end
  end

  # GET /admin/get_started_pages/1
  # GET /admin/get_started_pages/1.xml
  def show
    @get_started_panel = GetStartedPanel.new(get_started_page: @get_started_page)
    @get_started_page_product = GetStartedPageProduct.new(get_started_page: @get_started_page)
    @products = Product.all_for_website(website)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @get_started_page }
    end
  end

  # GET /admin/get_started_pages/new
  # GET /admin/get_started_pages/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @get_started_page }
    end
  end

  # GET /admin/get_started_pages/1/edit
  def edit
  end

  # POST /admin/get_started_pages
  # POST /admin/get_started_pages.xml
  def create
    @get_started_page.brand = website.brand
    respond_to do |format|
      if @get_started_page.save
        format.html { redirect_to([:admin, @get_started_page], notice: '"Get Started" page was successfully created.') }
        format.xml  { render xml: @get_started_page, status: :created, location: @get_started_page }
        website.add_log(user: current_user, action: "Created get_started_page: #{@get_started_page.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @get_started_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/get_started_pages/1
  # PUT /admin/get_started_pages/1.xml
  def update
    respond_to do |format|
      if @get_started_page.update_attributes(get_started_page_params)
        format.html { redirect_to([:admin, @get_started_page], notice: '"Get Started" page was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated get_started_page: #{@get_started_page.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @get_started_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # Delete banner
  def delete_image
    @get_started_page = GetStartedPage.find(params[:id])
    @get_started_page.update_attributes(header_image: nil)
    respond_to do |format|
      format.html { redirect_to(admin_get_started_page_path(@get_started_page), notice: "Banner was deleted.") }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted banner image from get started page: #{@get_started_page.name}")
  end

  # DELETE /admin/get_started_pages/1
  # DELETE /admin/get_started_pages/1.xml
  def destroy
    @get_started_page.destroy
    respond_to do |format|
      format.html { redirect_to(admin_get_started_pages_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted get_started_page: #{@get_started_page.title}")
  end

  private

  def initialize_get_started_page
    @get_started_page = GetStartedPage.new(get_started_page_params)
  end

  def get_started_page_params
    params.require(:get_started_page).permit!
  end
end
