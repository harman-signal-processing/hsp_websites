class Admin::OnlineRetailersController < AdminController
  before_filter :initialize_online_retailer, only: :create
  load_and_authorize_resource
  
  # GET /admin/online_retailers
  # GET /admin/online_retailers.xml
  def index
    @search = OnlineRetailer.ransack(params[:q])
    if params[:q]
      @online_retailers = @search.result.order(:name)
    else
      @online_retailers = @online_retailers.order(:name)
    end
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @online_retailers }
    end
  end

  # GET /admin/online_retailers/1
  # GET /admin/online_retailers/1.xml
  def show
    @online_retailer.brand_link = @online_retailer.get_brand_link(website)
    @online_retailer_link = OnlineRetailerLink.new(online_retailer: @online_retailer)
    @products = Product.non_discontinued(website) - @online_retailer.online_retailer_links.collect{|l| l.product} - ParentProduct.all.collect{|p| p.product}
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @online_retailer }
    end
  end

  # GET /admin/online_retailers/new
  # GET /admin/online_retailers/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @online_retailer }
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
        if params[:online_retailer][:brand_link] && !params[:online_retailer][:brand_link].blank?
          @online_retailer.set_brand_link(params[:online_retailer][:brand_link], website)
        end
        format.html { redirect_to([:admin, @online_retailer], notice: 'Online Retailer was successfully created.') }
        format.xml  { render xml: @online_retailer, status: :created, location: @online_retailer }
        website.add_log(user: current_user, action: "Created online retailer: #{@online_retailer.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @online_retailer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/online_retailers/1
  # PUT /admin/online_retailers/1.xml
  def update
    respond_to do |format|
      if @online_retailer.update_attributes(online_retailer_params)
        @online_retailer.set_brand_link(params[:online_retailer][:brand_link], website)
        format.html { redirect_to([:admin, @online_retailer], notice: 'Online Retailer was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated online retailer: #{@online_retailer.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @online_retailer.errors, status: :unprocessable_entity }
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
    website.add_log(user: current_user, action: "Deleted online retailer: #{@online_retailer.name}")
  end

  private

  def initialize_online_retailer
    @online_retailer = OnlineRetailer.new(online_retailer_params)
  end

  def online_retailer_params
    params.require(:online_retailer).permit!
  end
end
