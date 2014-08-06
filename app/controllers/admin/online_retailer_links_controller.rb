class Admin::OnlineRetailerLinksController < AdminController
  before_filter :initialize_online_retailer_link, only: :create
  load_and_authorize_resource  
  
  # GET /admin/online_retailer_links
  # GET /admin/online_retailer_links.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @online_retailer_links }
    end
  end

  # GET /admin/online_retailer_links/1
  # GET /admin/online_retailer_links/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @online_retailer_link }
    end
  end

  # GET /admin/online_retailer_links/new
  # GET /admin/online_retailer_links/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @online_retailer_link }
    end
  end

  # GET /admin/online_retailer_links/1/edit
  def edit
  end

  # POST /admin/online_retailer_links
  # POST /admin/online_retailer_links.xml
  def create
    @called_from = params[:called_from] || 'product'
    respond_to do |format|
      if @online_retailer_link.save
        @products = Product.non_discontinued(website) - @online_retailer_link.online_retailer.online_retailer_links.collect{|l| l.product}
        format.html { redirect_to([:admin, @online_retailer_link], notice: 'Link was successfully created.') }
        format.xml  { render xml: @online_retailer_link, status: :created, location: @online_retailer_link }
        format.js
        website.add_log(user: current_user, action: "Created buy-it-now link: #{@online_retailer_link.product.name} at #{@online_retailer_link.online_retailer.name} to #{@online_retailer_link.url}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @online_retailer_link.errors, status: :unprocessable_entity }
        format.js { render text: "Error"}
      end
    end
  end

  # PUT /admin/online_retailer_links/1
  # PUT /admin/online_retailer_links/1.xml
  def update
    respond_to do |format|
      if @online_retailer_link.update_attributes(online_retailer_link_params)
        format.html { redirect_to([:admin, @online_retailer_link.online_retailer], notice: 'Link was successfully updated.') }
        format.xml  { head :ok }
        format.js
        website.add_log(user: current_user, action: "Updated buy-it-now link: #{@online_retailer_link.product.name} at #{@online_retailer_link.online_retailer.name} to #{@online_retailer_link.url}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @online_retailer_link.errors, status: :unprocessable_entity }
        format.js { render text: "Error"}
      end
    end
  end

  # DELETE /admin/online_retailer_links/1
  # DELETE /admin/online_retailer_links/1.xml
  def destroy
    @online_retailer_link.destroy
    @products = Product.non_discontinued(website) - @online_retailer_link.online_retailer.online_retailer_links.collect{|l| l.product}
    respond_to do |format|
      format.html { redirect_to([:admin, @online_retailer_link.online_retailer]) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted buy-it-now link: #{@online_retailer_link.product.name} at #{@online_retailer_link.online_retailer.name}")
  end

  private

  def initialize_online_retailer_link
    @online_retailer_link = OnlineRetailerLink.new(online_retailer_link_params)
  end

  def online_retailer_link_params
    params.require(:online_retailer_link).permit!
  end
end
