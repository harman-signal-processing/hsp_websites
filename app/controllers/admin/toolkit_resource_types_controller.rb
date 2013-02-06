class Admin::ToolkitResourceTypesController < AdminController
  load_and_authorize_resource
  # GET /toolkit_resource_types
  # GET /toolkit_resource_types.xml
  def index
    @types_for_menu = @toolkit_resource_types.where("position IS NOT NULL")
    @non_menu_types = @toolkit_resource_types.where("position IS NULL")
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @toolkit_resource_types }
    end
  end

  # GET /toolkit_resource_types/1
  # GET /toolkit_resource_types/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @toolkit_resource_type }
    end
  end

  # GET /toolkit_resource_types/new
  # GET /toolkit_resource_types/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @toolkit_resource_type }
    end
  end

  # GET /toolkit_resource_types/1/edit
  def edit
  end

  # POST /toolkit_resource_types
  # POST /toolkit_resource_types.xml
  def create
    respond_to do |format|
      if @toolkit_resource_type.save
        format.html { redirect_to([:admin, @toolkit_resource_type], notice: 'Toolkit resource type was successfully created.') }
        format.xml  { render xml: @toolkit_resource, status: :created, location: @toolkit_resource_type }
        website.add_log(user: current_user, action: "Created toolkit resource: #{@toolkit_resource_type.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @toolkit_resource_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /toolkit_resource_types/1
  # PUT /toolkit_resource_types/1.xml
  def update
    respond_to do |format|
      if @toolkit_resource_type.update_attributes(params[:toolkit_resource_type])
        format.html { redirect_to([:admin, @toolkit_resource_type], notice: 'Toolkit resource type was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated toolkit resource: #{@toolkit_resource_type.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @toolkit_resource_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /toolkit_resource_types/1
  # DELETE /toolkit_resource_types/1.xml
  def destroy
    @toolkit_resource_type.destroy
    respond_to do |format|
      format.html { redirect_to(admin_toolkit_resource_types_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted toolkit resource type: #{@toolkit_resource_type.name}")
  end
end
