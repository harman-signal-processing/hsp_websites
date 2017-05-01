class Admin::SiteElementsController < AdminController
  before_action :initialize_site_element, only: :create
  load_and_authorize_resource

  # GET /site_elements
  # GET /site_elements.xml
  def index
    @site_elements = @site_elements.where(brand_id: website.brand_id)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @site_elements }
    end
  end

  # GET /site_elements/1
  # GET /site_elements/1.xml
  def show
    @product_site_element = ProductSiteElement.new(site_element_id: @site_element.id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @site_element }
    end
  end

  # GET /site_elements/new
  # GET /site_elements/new.xml
  def new
    @site_element.show_on_public_site = true
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @site_element }
    end
  end

  # GET /site_elements/1/edit
  def edit
  end

  # POST /site_elements
  # POST /site_elements.xml
  def create
    @site_element.brand_id = website.brand_id
    respond_to do |format|
      if @site_element.save
        format.html { redirect_to([:admin, @site_element], notice: 'Resource was successfully created.') }
        format.xml  { render xml: @site_element, status: :created, location: @site_element }
        website.add_log(user: current_user, action: "Uploaded a site element: #{@site_element.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @site_element.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /site_elements/1
  # PUT /site_elements/1.xml
  def update
    respond_to do |format|
      if @site_element.update_attributes(site_element_params)
        format.html { redirect_to([:admin, @site_element], notice: 'Resource was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated a site element: #{@site_element.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @site_element.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /site_elements/1
  # DELETE /site_elements/1.xml
  def destroy
    @site_element.destroy
    respond_to do |format|
      format.html { redirect_to(admin_site_elements_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted a site element: #{@site_element.name}")
  end

  private

  def initialize_site_element
    @site_element = SiteElement.new(site_element_params)
  end

  def site_element_params
    params.require(:site_element).permit!
  end
end
