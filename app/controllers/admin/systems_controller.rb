class Admin::SystemsController < AdminController
  before_action :initialize_system, only: :create
  load_and_authorize_resource

  # GET /admin/systems
  # GET /admin/systems.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @systems }
    end
  end

  # GET /admin/systems/1
  # GET /admin/systems/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @system }
    end
  end

  # GET /admin/systems/new
  # GET /admin/systems/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @system }
    end
  end

  # GET /admin/systems/1/edit
  def edit
  end

  # POST /admin/systems
  # POST /admin/systems.xml
  def create
  	@system.brand = website.brand
    respond_to do |format|
      if @system.save
        format.html { redirect_to([:admin, @system], notice: 'System was successfully created.') }
        format.xml  { render xml: @system, status: :created, location: @system }
        website.add_log(user: current_user, action: "Created system: #{@system.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @system.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/systems/1
  # PUT /admin/systems/1.xml
  def update
    respond_to do |format|
      if @system.update_attributes(system_params)
        format.html { redirect_to([:admin, @system], notice: 'System was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated spec: #{@system.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @system.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/systems/1
  # DELETE /admin/systems/1.xml
  def destroy
    @system.destroy
    respond_to do |format|
      format.html { redirect_to(admin_systems_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted system: #{@system.name}")
  end  

  private

  def initialize_system
    @system = System.new(system_params)
  end

  def system_params
    params.require(:system).permit!
  end


end
