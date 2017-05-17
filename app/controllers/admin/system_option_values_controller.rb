class Admin::SystemOptionValuesController < AdminController
  before_action :initialize_system_option_value, only: :create
  before_action :set_system, except: [:update_order]
  before_action :set_system_option, except: [:update_order]
  load_and_authorize_resource

  # GET /admin/system/SYSTEM_ID/system_option/SYSTEM_OPTION_ID/system_option_values/1
  # GET /admin/system/SYSTEM_ID/system_option/SYSTEM_OPTION_ID/system_option_values/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @system_option_value }
    end
  end

  # GET /admin/system/SYSTEM_ID/system_option/SYSTEM_OPTION_ID/system_option_values/new
  # GET /admin/system/SYSTEM_ID/system_option/SYSTEM_OPTION_ID/system_option_values/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @system_option_value }
    end
  end

  # GET /admin/system/SYSTEM_ID/system_option/SYSTEM_OPTION_ID/system_option_values/1/edit
  def edit
  end

  # POST /admin/system/SYSTEM_ID/system_option/SYSTEM_OPTION_ID/system_option_values
  # POST /admin/system/SYSTEM_ID/system_option/SYSTEM_OPTION_ID/system_option_values.xml
  def create
  	@system_option_value.system_option = @system_option
    respond_to do |format|
      if @system_option_value.save
        format.html { redirect_to([:admin, @system, @system_option], notice: 'System Option Value was successfully created.') }
        format.xml  { render xml: @system_option_value, status: :created, location: @system_option_value }
        format.js
        website.add_log(user: current_user, action: "Created system_option_value: #{@system_option_value.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @system_option_value.errors, status: :unprocessable_entity }
        format.js { render template: "admin/system_option_values/create_error" }
      end
    end
  end

  # PUT /admin/system/SYSTEM_ID/system_option/SYSTEM_OPTION_ID/system_option_values/1
  # PUT /admin/system/SYSTEM_ID/system_option/SYSTEM_OPTION_ID/system_option_values/1.xml
  def update
    respond_to do |format|
      if @system_option_value.update_attributes(system_option_value_params)
        format.html { redirect_to([:admin, @system, @system_option], notice: 'System Option Value was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated system option value: #{@system_option_value.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @system_option_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/system_option_values/update_order
  def update_order
    update_list_order(SystemOptionValue, params["system_option_value"])
    head :ok
    website.add_log(user: current_user, action: "Sorted system option_values")
  end

  # DELETE /admin/system/SYSTEM_ID/system_option/SYSTEM_OPTION_ID/system_option_values/1
  # DELETE /admin/system/SYSTEM_ID/system_option/SYSTEM_OPTION_ID/system_option_values/1.xml
  def destroy
    @system_option_value.destroy
    respond_to do |format|
      format.html { redirect_to [:admin, @system, @system_option] }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted system_option_value: #{@system_option_value.name}")
  end

  private

  def set_system
    @system = System.find(params[:system_id])
  end

  def set_system_option
    @system_option = @system.system_options.find(params[:system_option_id])
  end

  def initialize_system_option_value
    @system_option_value = SystemOptionValue.new(system_option_value_params)
  end

  def system_option_value_params
    params.require(:system_option_value).permit!
  end


end
