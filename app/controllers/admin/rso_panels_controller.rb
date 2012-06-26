class Admin::RsoPanelsController < AdminController
  load_and_authorize_resource
  
  # GET /rso_panels
  # GET /rso_panels.xml
  def index
    @rso_panels = @rso_panels.where(:brand_id => website.brand_id).order("upper(name)")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rso_panels }
    end
  end

  # GET /rso_panels/1
  # GET /rso_panels/1.xml
  def show
    @rso_navigation = RsoNavigation.new(:rso_panel_id => @rso_panel.id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rso_panel }
    end
  end

  # GET /rso_panels/new
  # GET /rso_panels/new.xml
  def new
    @rso_panel.name = "main"
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rso_panel }
    end
  end

  # GET /rso_panels/1/edit
  def edit
    redirect_to [:admin, @rso_panel] if @rso_panel.name == "left"
  end

  # POST /rso_panels
  # POST /rso_panels.xml
  def create
    @rso_panel.brand_id = website.brand_id
    respond_to do |format|
      if @rso_panel.save
        format.html { redirect_to([:admin, @rso_panel], :notice => 'Panel was successfully created.') }
        format.xml  { render :xml => @rso_panel, :status => :created, :location => @rso_panel }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rso_panel.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rso_panels/1
  # PUT /rso_panels/1.xml
  def update
    respond_to do |format|
      if @rso_panel.update_attributes(params[:rso_panel])
        format.html { redirect_to([:admin, @rso_panel], :notice => 'Panel was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rso_panel.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rso_panels/1
  # DELETE /rso_panels/1.xml
  def destroy
    @rso_panel.destroy
    respond_to do |format|
      format.html { redirect_to(admin_rso_panels_url) }
      format.xml  { head :ok }
    end
  end
end
