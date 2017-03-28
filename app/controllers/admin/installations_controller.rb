class Admin::InstallationsController < AdminController
  before_action :initialize_installation, only: :create
  load_and_authorize_resource

  # GET /admin/installations
  # GET /admin/installations.xml
  def index
    @installations = @installations.where(brand_id: website.brand_id).order("UPPER(title)")
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @installations }
    end
  end

  # GET /admin/installations/1
  # GET /admin/installations/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @installation }
    end
  end

  # GET /admin/installations/new
  # GET /admin/installations/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @installation }
    end
  end

  # GET /admin/installations/1/edit
  def edit
  end

  # POST /admin/installations
  # POST /admin/installations.xml
  def create
    @installation.brand = website.brand
    respond_to do |format|
      if @installation.save
        format.html { redirect_to([:admin, @installation], notice: 'Installation was successfully created.') }
        format.xml  { render xml: @installation, status: :created, location: @installation }
        website.add_log(user: current_user, action: "Created installation: #{@installation.title}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @installation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/installations/1
  # PUT /admin/installations/1.xml
  def update
    respond_to do |format|
      if @installation.update_attributes(installation_params)
        format.html { redirect_to([:admin, @installation], notice: 'Installation was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated installation: #{@installation.title}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @installation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/installations/1
  # DELETE /admin/installations/1.xml
  def destroy
    @installation.destroy
    respond_to do |format|
      format.html { redirect_to(admin_installations_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted installation: #{@installation.title}")
  end

  private

  def initialize_installation
    @installation = Installation.new(installation_params)
  end

  def installation_params
    params.require(:installation).permit!
  end
end
