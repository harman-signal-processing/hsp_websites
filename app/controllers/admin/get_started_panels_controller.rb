class Admin::GetStartedPanelsController < AdminController
  before_action :initialize_get_started_panel, only: :create
  before_action :set_get_started_page
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @get_started_panels }
    end
  end

  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @get_started_panel }
    end
  end

  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @get_started_panel }
    end
  end

  def edit
  end

  def create
  	@get_started_panel.get_started_page = @get_started_page
    respond_to do |format|
      if @get_started_panel.save
        format.html { redirect_to([:admin, @get_started_page], notice: 'Panel was successfully created.') }
        format.xml  { render xml: @get_started_panel, status: :created, location: @get_started_panel }
        format.js
        website.add_log(user: current_user, action: "Created get started panel: #{@get_started_panel.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @get_started_panel.errors, status: :unprocessable_entity }
        format.js { render template: "admin/get_started_panels/create_error" }
      end
    end
  end

  def update
    respond_to do |format|
      if @get_started_panel.update_attributes(get_started_panel_params)
        format.html { redirect_to([:admin, @get_started_page], notice: 'Panel was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated panel: #{@get_started_panel.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @get_started_panel.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @get_started_panel.destroy
    respond_to do |format|
      format.html { redirect_to [:admin, @get_started_page] }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted get_started_panel: #{@get_started_panel.name}")
  end

  private

  def set_get_started_page
    @get_started_page = GetStartedPage.find(params[:get_started_page_id])
  end

  def initialize_get_started_panel
    @get_started_panel = GetStartedPanel.new(get_started_panel_params)
  end

  def get_started_panel_params
    params.require(:get_started_panel).permit!
  end


end
