class Admin::WarrantyRegistrationsController < AdminController
  load_and_authorize_resource
  # GET /admin/warranty_registrations
  # GET /admin/warranty_registrations.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { 
        @warranty_registrations = WarrantyRegistration.all
        render :xml => @warranty_registrations 
      }
    end
  end
  
  # PUT /admin/warranty_registrations/search
  def search
    @warranty_registrations = WarrantyRegistrations.search(params[:search_string])
    respond_to do |format|
      format.html
    end
  end

  # GET /admin/warranty_registrations/1
  # GET /admin/warranty_registrations/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render :xml => @warranty_registration }
    end
  end

  # GET /admin/warranty_registrations/new
  # GET /admin/warranty_registrations/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render :xml => @warranty_registration }
    end
  end

  # GET /admin/warranty_registrations/1/edit
  def edit
  end

  # POST /admin/warranty_registrations
  # POST /admin/warranty_registrations.xml
  def create
    respond_to do |format|
      if @warranty_registration.save
        format.html { redirect_to([:admin, @warranty_registration], :notice => 'Warranty registration was successfully created.') }
        format.xml  { render :xml => @warranty_registration, :status => :created, :location => @warranty_registration }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @warranty_registration.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/warranty_registrations/1
  # PUT /admin/warranty_registrations/1.xml
  def update
    respond_to do |format|
      if @warranty_registration.update_attributes(params[:warranty_registration])
        format.html { redirect_to([:admin, @warranty_registration], :notice => 'Warranty registration was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @warranty_registration.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/warranty_registrations/1
  # DELETE /admin/warranty_registrations/1.xml
  def destroy
    @warranty_registration.destroy
    respond_to do |format|
      format.html { redirect_to(admin_warranty_registrations_url) }
      format.xml  { head :ok }
    end
  end
end
