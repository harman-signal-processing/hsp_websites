class Admin::RsoPagesController < AdminController
  load_and_authorize_resource
  
  # GET /rso_pages
  # GET /rso_pages.xml
  def index
    @rso_pages = @rso_pages.where(brand_id: website.brand_id).order("UPPER(name)")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @rso_pages }
    end
  end

  # GET /rso_pages/1
  # GET /rso_pages/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @rso_page }
    end
  end

  # GET /rso_pages/new
  # GET /rso_pages/new.xml
  def new
    @rso_page.add_to_nav = true
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @rso_page }
    end
  end

  # GET /rso_pages/1/edit
  def edit
  end

  # POST /rso_pages
  # POST /rso_pages.xml
  def create
    @rso_page.brand_id = website.brand_id
    respond_to do |format|
      if @rso_page.save
        format.html { redirect_to([:admin, @rso_page], notice: 'RSO site page was successfully created.') }
        format.xml  { render xml: @rso_page, status: :created, location: @rso_page }
      else
        format.html { render action: "new" }
        format.xml  { render xml: @rso_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /rso_pages/1
  # PUT /rso_pages/1.xml
  def update
    respond_to do |format|
      if @rso_page.update_attributes(params[:rso_page])
        format.html { redirect_to([:admin, @rso_page], notice: 'Page was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @rso_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rso_pages/1
  # DELETE /rso_pages/1.xml
  def destroy
    @rso_page.destroy
    respond_to do |format|
      format.html { redirect_to(rso_pages_url) }
      format.xml  { head :ok }
    end
  end
end
