class Admin::SystemRulesController < AdminController
  before_action :initialize_system_rule, only: :create
  before_action :set_system
  load_and_authorize_resource

  # GET /admin/system/SYSTEM_ID/system_rules
  # GET /admin/system/SYSTEM_ID/system_rules.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @system_rules }
    end
  end

  # GET /admin/system/SYSTEM_ID/system_rules/1
  # GET /admin/system/SYSTEM_ID/system_rules/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @system_rule }
    end
  end

  # GET /admin/system/SYSTEM_ID/system_rules/new
  # GET /admin/system/SYSTEM_ID/system_rules/new.xml
  def new
    2.times { @system_rule.system_rule_condition_groups.build }
    2.times { @system_rule.system_rule_actions.build }
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @system_rule }
    end
  end

  # GET /admin/system/SYSTEM_ID/system_rules/1/edit
  def edit
  end

  # POST /admin/system/SYSTEM_ID/system_rules
  # POST /admin/system/SYSTEM_ID/system_rules.xml
  def create
  	@system_rule.system = @system
    respond_to do |format|
      if @system_rule.save
        format.html { redirect_to([:admin, @system], notice: 'System Rule was successfully created.') }
        format.xml  { render xml: @system_rule, status: :created, location: @system_rule }
        format.js
        website.add_log(user: current_user, action: "Created system_rule: #{@system_rule.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @system_rule.errors, status: :unprocessable_entity }
        format.js { render template: "admin/system_rules/create_error" }
      end
    end
  end

  # PUT /admin/system/SYSTEM_ID/system_rules/1
  # PUT /admin/system/SYSTEM_ID/system_rules/1.xml
  def update
    respond_to do |format|
      if @system_rule.update(system_rule_params)
        format.html { redirect_to([:admin, @system], notice: 'System Rule was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated system_rule: #{@system_rule.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @system_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  def enable_all
    @system.system_rules.update_all(enabled: true)
    redirect_to [:admin, @system], notice: 'All rules were enabled.'
  end

  def disable_all
    @system.system_rules.update_all(enabled: false)
    redirect_to [:admin, @system], notice: 'All rules were disabled.'
  end

  # DELETE /admin/system/SYSTEM_ID/system_rules/1
  # DELETE /admin/system/SYSTEM_ID/system_rules/1.xml
  def destroy
    @system_rule.destroy
    respond_to do |format|
      format.html { redirect_to [:admin, @system] }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted system_rule: #{@system_rule.name}")
  end  

  private

  def set_system
    @system = System.find(params[:system_id])
  end

  def initialize_system_rule
    @system_rule = SystemRule.new(system_rule_params)
  end

  def system_rule_params
    params.require(:system_rule).permit!
  end


end
