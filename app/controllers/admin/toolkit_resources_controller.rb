class Admin::ToolkitResourcesController < AdminController
  before_action :initialize_toolkit_resource, only: :create
  load_and_authorize_resource
  
  # GET /toolkit_resources
  # GET /toolkit_resources.xml
  def index
    @search = ToolkitResource.where(brand_id: website.brand_id).ransack(params[:q])
    if params[:q]
      @toolkit_resources = @search.result(:distinct => true)
    else
      @toolkit_resources = []
      @marketing_message_type = ToolkitResourceType.where(marketing_message: true).first
      @marketing_messages = ToolkitResource.where(brand_id: website.brand_id, toolkit_resource_type_id: @marketing_message_type.id).where("expires_on > ? OR expires_on IS NULL", Time.now.advance(days: -15))
    end
    @bad_links = ToolkitResource.where(brand_id: website.brand_id, link_good: false)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @toolkit_resources }
    end
  end

  # GET /toolkit_resources/1
  # GET /toolkit_resources/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @toolkit_resource }
    end
  end

  # GET /toolkit_resources/new
  # GET /toolkit_resources/new.xml
  def new
    @toolkit_resource.toolkit_resource_type_id = params[:toolkit_resource_type_id]
    # @toolkit_resource.dealer      = false
    # @toolkit_resource.distributor = false
    # @toolkit_resource.rep         = false
    # @toolkit_resource.rso         = false
    # @toolkit_resource.media       = false
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @toolkit_resource }
    end
  end

  # GET /toolkit_resources/1/edit
  def edit
  end

  # POST /toolkit_resources
  # POST /toolkit_resources.xml
  def create
    @toolkit_resource.brand_id ||= website.brand_id
    respond_to do |format|
      if @toolkit_resource.save
        format.html { redirect_to([:admin, @toolkit_resource], notice: 'Toolkit resource was successfully created.') }
        format.xml  { render xml: @toolkit_resource, status: :created, location: @toolkit_resource }
        website.add_log(user: current_user, action: "Created toolkit resource: #{@toolkit_resource.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @toolkit_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /toolkit_resources/1
  # PUT /toolkit_resources/1.xml
  def update
    params[:toolkit_resource][:link_good] = true
    respond_to do |format|
      if @toolkit_resource.update(toolkit_resource_params)
        format.html { redirect_to([:admin, @toolkit_resource], notice: 'Toolkit resource was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated toolkit resource: #{@toolkit_resource.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @toolkit_resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /toolkit_resources/1/delete_preview
  def delete_preview
    @toolkit_resource.delete_preview
    redirect_to([:admin, @toolkit_resource], notice: "Preview image was removed.")
  end

  # DELETE /toolkit_resources/1
  # DELETE /toolkit_resources/1.xml
  def destroy
    @toolkit_resource.destroy
    respond_to do |format|
      format.html { redirect_to(admin_toolkit_resources_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted toolkit resource: #{@toolkit_resource.name}")
  end

  private

  def initialize_toolkit_resource
    @toolkit_resource = ToolkitResource.new(toolkit_resource_params)
  end

  def toolkit_resource_params
    params.require(:toolkit_resource).permit!
  end
end
