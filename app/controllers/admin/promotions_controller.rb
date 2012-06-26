class Admin::PromotionsController < AdminController
  load_and_authorize_resource
  # GET /admin/promotions
  # GET /admin/promotions.xml
  def index
    @promotions = @promotions.where(:brand_id => website.brand_id)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render :xml => @promotions }
    end
  end

  # GET /admin/promotions/1
  # GET /admin/promotions/1.xml
  def show
    @product_promotion = ProductPromotion.new(:promotion => @promotion)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render :xml => @promotion }
    end
  end

  # GET /admin/promotions/new
  # GET /admin/promotions/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render :xml => @promotion }
    end
  end

  # GET /admin/promotions/1/edit
  def edit
  end

  # POST /admin/promotions
  # POST /admin/promotions.xml
  def create
    @promotion.brand = website.brand
    respond_to do |format|
      if @promotion.save
        format.html { redirect_to([:admin, @promotion], :notice => 'Promotion was successfully created.') }
        format.xml  { render :xml => @promotion, :status => :created, :location => @promotion }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @promotion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/promotions/1
  # PUT /admin/promotions/1.xml
  def update
    respond_to do |format|
      if @promotion.update_attributes(params[:promotion])
        format.html { redirect_to([:admin, @promotion], :notice => 'Promotion was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @promotion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/promotions/1
  # DELETE /admin/promotions/1.xml
  def destroy
    @promotion.destroy
    respond_to do |format|
      format.html { redirect_to(admin_promotions_url) }
      format.xml  { head :ok }
    end
  end
end
