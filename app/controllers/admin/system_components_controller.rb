class Admin::SystemComponentsController < AdminController
  before_action :initialize_system_component, only: :create
  before_action :set_system
  load_and_authorize_resource

  # GET /admin/system/SYSTEM_ID/system_components
  # GET /admin/system/SYSTEM_ID/system_components.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @system_components }
    end
  end

  # GET /admin/system/SYSTEM_ID/system_components/1
  # GET /admin/system/SYSTEM_ID/system_components/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @system_component }
    end
  end

  # GET /admin/system/SYSTEM_ID/system_components/new
  # GET /admin/system/SYSTEM_ID/system_components/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @system_component }
    end
  end

  # GET /admin/system/SYSTEM_ID/system_components/1/edit
  def edit
  end

  # POST /admin/system/SYSTEM_ID/system_components
  # POST /admin/system/SYSTEM_ID/system_components.xml
  def create
  	@system_component.system = @system
    respond_to do |format|
      if @system_component.save
        format.html { redirect_to([:admin, @system], notice: 'System Component was successfully created.') }
        format.xml  { render xml: @system_component, status: :created, location: @system_component }
        format.js
        website.add_log(user: current_user, action: "Created system_component: #{@system_component.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @system_component.errors, status: :unprocessable_entity }
        format.js { render template: "admin/system_components/create_error" }
      end
    end
  end

  # PUT /admin/system/SYSTEM_ID/system_components/1
  # PUT /admin/system/SYSTEM_ID/system_components/1.xml
  def update
    respond_to do |format|
      if @system_component.update(system_component_params)
        format.html { redirect_to([:admin, @system], notice: 'System Component was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated spec: #{@system_component.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @system_component.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/system/SYSTEM_ID/system_components/1
  # DELETE /admin/system/SYSTEM_ID/system_components/1.xml
  def destroy
    @system_component.destroy
    respond_to do |format|
      format.html { redirect_to [:admin, @system] }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted system_component: #{@system_component.name}")
  end

  private

  def set_system
    @system = System.find(params[:system_id])
  end

  def initialize_system_component
    @system_component = SystemComponent.new(system_component_params)
  end

  def system_component_params
    params.require(:system_component).permit(
      :name,
      :system_id,
      :product_id,
      :description
    )
  end


end
