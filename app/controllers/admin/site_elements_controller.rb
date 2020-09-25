class Admin::SiteElementsController < AdminController
  before_action :initialize_site_element, only: :create
  load_and_authorize_resource

  # GET /site_elements
  # GET /site_elements.xml
  def index
    brand_site_elements = @site_elements.where(brand_id: website.brand_id)
    @search = brand_site_elements.ransack(params[:q])
    if params[:q]
      @site_elements = @search.result.order(:name, :version).paginate(page: params[:page], per_page: 50)
    else
      @site_elements = brand_site_elements.paginate(page: params[:page], per_page: 50)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @site_elements }
    end
  end

  # GET /site_elements/1
  # GET /site_elements/1.xml
  def show
    @product_site_element = ProductSiteElement.new(site_element_id: @site_element.id)
    @site_element_attachment = SiteElementAttachment.new
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

  def new_version
    @old_element = @site_element
    @site_element = SiteElement.new
    @site_element.replaces_element = @old_element.to_param
  end

  # GET /site_elements/1/edit
  def edit
  end

  # POST /admin/site_elements/upload
  # Callback after uploading a file directly to S3. Adds the temporary S3 path
  # to the form before creating new software.
  def upload
    @direct_upload_url = params[:direct_upload_url]
    respond_to do |format|
      format.js
    end
  end

  # POST /site_elements
  # POST /site_elements.xml
  def create
    @site_element.brand_id = website.brand_id
    respond_to do |format|
      if @site_element.save
        format.html { redirect_to([:admin, @site_element], notice: 'Resource was successfully created. IMPORTANT: this has been acting up lately. Wait 5 seconds, then refresh this page. Then the links below will be correct.') }
        format.xml  { render xml: @site_element, status: :created, location: @site_element }
        website.add_log(user: current_user, action: "Uploaded a site element: #{@site_element.long_name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @site_element.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /site_elements/1
  # PUT /site_elements/1.xml
  def update
    other_versions = @site_element.other_versions
    respond_to do |format|
      if @site_element.update(site_element_params)
        other_versions.each{|element| element.catchup_with_latest_version(@site_element)}
        format.html { redirect_to([:admin, @site_element], notice: 'Resource was successfully updated. It may take a few seconds to process and transfer the file to the right place.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated a site element: #{@site_element.long_name}")
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
    website.add_log(user: current_user, action: "Deleted a site element: #{@site_element.long_name}")
  end

  private

  def initialize_site_element
    @site_element = SiteElement.new(site_element_params)
  end

  def site_element_params
    params.require(:site_element).permit!
  end
end
