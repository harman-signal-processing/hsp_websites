class Admin::OnlineRetailersController < AdminController
  load_and_authorize_resource
  # GET /admin/online_retailers
  # GET /admin/online_retailers.xml
  def index
    @online_retailers = @online_retailers.order(:name)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render :xml => @online_retailers }
    end
  end

  # GET /admin/online_retailers/1
  # GET /admin/online_retailers/1.xml
  def show
    @online_retailer.brand_link = @online_retailer.get_brand_link(website)
    @online_retailer_link = OnlineRetailerLink.new(:online_retailer => @online_retailer)
    @products = Product.non_discontinued(website) - @online_retailer.online_retailer_links.collect{|l| l.product}
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render :xml => @online_retailer }
    end
  end

  # GET /admin/online_retailers/new
  # GET /admin/online_retailers/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render :xml => @online_retailer }
    end
  end

  # GET /admin/online_retailers/1/edit
  def edit
    @online_retailer.brand_link = @online_retailer.get_brand_link(website)
  end

  # POST /admin/online_retailers
  # POST /admin/online_retailers.xml
  def create
    respond_to do |format|
      if @online_retailer.save
        # update the newly created OnlineRetailer in order to add the default URL
        @online_retailer.set_brand_link(params[:online_retailer][:brand_link], website)
        format.html { redirect_to([:admin, @online_retailer], :notice => 'Online Retailer was successfully created.') }
        format.xml  { render :xml => @online_retailer, :status => :created, :location => @online_retailer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @online_retailer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/online_retailers/1
  # PUT /admin/online_retailers/1.xml
  def update
    respond_to do |format|
      if @online_retailer.update_attributes(params[:online_retailer])
        @online_retailer.set_brand_link(params[:online_retailer][:brand_link], website)
        format.html { redirect_to([:admin, @online_retailer], :notice => 'Online Retailer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @online_retailer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/online_retailers/1
  # DELETE /admin/online_retailers/1.xml
  def destroy
    @online_retailer.destroy
    respond_to do |format|
      format.html { redirect_to(admin_online_retailers_url) }
      format.xml  { head :ok }
    end
  end
end
