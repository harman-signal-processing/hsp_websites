class Admin::SystemOptionsController < AdminController
  before_action :initialize_system_option, only: :create
  before_action :set_system, except: [:update_order]
  load_and_authorize_resource

  # GET /admin/system/SYSTEM_ID/system_options
  # GET /admin/system/SYSTEM_ID/system_options.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @system_options }
    end
  end

  # GET /admin/system/SYSTEM_ID/system_options/1
  # GET /admin/system/SYSTEM_ID/system_options/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @system_option }
    end
  end

  # GET /admin/system/SYSTEM_ID/system_options/new
  # GET /admin/system/SYSTEM_ID/system_options/new.xml
  def new
    3.times { @system_option.system_option_values.build }
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @system_option }
    end
  end

  # GET /admin/system/SYSTEM_ID/system_options/1/edit
  def edit
    @system_option.system_option_values.build
  end

  # POST /admin/system/SYSTEM_ID/system_options
  # POST /admin/system/SYSTEM_ID/system_options.xml
  def create
  	@system_option.system = @system
    respond_to do |format|
      if @system_option.save
        format.html { redirect_to([:admin, @system], notice: 'System Option was successfully created.') }
        format.xml  { render xml: @system_option, status: :created, location: @system_option }
        format.js
        website.add_log(user: current_user, action: "Created system_option: #{@system_option.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @system_option.errors, status: :unprocessable_entity }
        format.js { render template: "admin/system_options/create_error" }
      end
    end
  end

  # PUT /admin/system/SYSTEM_ID/system_options/1
  # PUT /admin/system/SYSTEM_ID/system_options/1.xml
  def update
    respond_to do |format|
      if @system_option.update_attributes(system_option_params)
        format.html { redirect_to([:admin, @system], notice: 'System Option was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated system option: #{@system_option.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @system_option.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/system_options/update_order
  def update_order
    update_list_order(SystemOption, params["system_option"])
    head :ok
    website.add_log(user: current_user, action: "Sorted system options")
  end

  # DELETE /admin/system/SYSTEM_ID/system_options/1
  # DELETE /admin/system/SYSTEM_ID/system_options/1.xml
  def destroy
    @system_option.destroy
    respond_to do |format|
      format.html { redirect_to [:admin, @system] }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted system_option: #{@system_option.name}")
  end  

  private

  def set_system
    @system = System.find(params[:system_id])
  end

  def initialize_system_option
    @system_option = SystemOption.new(system_option_params)
  end

  def system_option_params
    params.require(:system_option).permit!
  end


end
