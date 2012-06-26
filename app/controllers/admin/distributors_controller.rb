class Admin::DistributorsController < AdminController
  load_and_authorize_resource
  # GET /admin/distributors
  # GET /admin/distributors.xml
  def index
    @distributors = BrandDistributor.where(:brand_id => website.brand_id).all.collect{|bd| bd.distributor}
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render :xml => @distributors }
    end
  end

  # GET /admin/distributors/1
  # GET /admin/distributors/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render :xml => @distributor }
    end
  end

  # GET /admin/distributors/new
  # GET /admin/distributors/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render :xml => @distributor }
    end
  end

  # GET /admin/distributors/1/edit
  def edit
  end

  # POST /admin/distributors
  # POST /admin/distributors.xml
  def create
    respond_to do |format|
      if @distributor.save
        @distributor.create_brand_distributor(website)
        format.html { redirect_to([:admin, @distributor], :notice => 'Distributor was successfully created.') }
        format.xml  { render :xml => @distributor, :status => :created, :location => @distributor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @distributor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/distributors/1
  # PUT /admin/distributors/1.xml
  def update
    respond_to do |format|
      if @distributor.update_attributes(params[:distributor])
        format.html { redirect_to([:admin, @distributor], :notice => 'Distributor was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @distributor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/distributors/1
  # DELETE /admin/distributors/1.xml
  def destroy
    if @distributor.brand_distributors.size <= 1
      @distributor.destroy
    else
      @distributor.brand_distributors.each do |db|
        db.destroy if db.brand == website.brand
      end
    end
    respond_to do |format|
      format.html { redirect_to(admin_distributors_url) }
      format.xml  { head :ok }
    end
  end
end
