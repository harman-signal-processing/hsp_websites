class Admin::ProductSoftwaresController < AdminController
  load_and_authorize_resource
  after_filter :expire_software_index_cache, :only => [:create, :update, :destroy]
  
  # GET /admin/product_softwares
  # GET /admin/product_softwares.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render :xml => @product_softwares }
    end
  end

  # GET /admin/product_softwares/1
  # GET /admin/product_softwares/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render :xml => @product_software }
    end
  end

  # GET /admin/product_softwares/new
  # GET /admin/product_softwares/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render :xml => @product_software }
    end
  end

  # GET /admin/product_softwares/1/edit
  def edit
  end

  # POST /admin/product_softwares
  # POST /admin/product_softwares.xml
  def create
    @called_from = params[:called_from] || 'product'
    respond_to do |format|
      if @product_software.save
        format.html { redirect_to([:admin, @product_software], :notice => 'ProductSoftware was successfully created.') }
        format.xml  { render :xml => @product_software, :status => :created, :location => @product_software }
        format.js
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product_software.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /admin/product_softwares/1
  # PUT /admin/product_softwares/1.xml
  def update
    respond_to do |format|
      if @product_software.update_attributes(params[:product_software])
        format.html { redirect_to([:admin, @product_software], :notice => 'ProductSoftware was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product_software.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/product_softwares/1
  # DELETE /admin/product_softwares/1.xml
  def destroy
    @product_software.destroy
    respond_to do |format|
      format.html { redirect_to(admin_product_softwares_url) }
      format.xml  { head :ok }
      format.js
    end
  end
end
