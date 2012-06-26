class Admin::EffectsController < AdminController
  load_and_authorize_resource
  # GET /effects
  # GET /effects.xml
  def index
    @effects = @effects.order(:effect_type_id)
    @effect_types = EffectType.order(:position)
    @effect_type = EffectType.new
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render :xml => @effects }
    end
  end

  # GET /effects/1
  # GET /effects/1.xml
  def show
    @product_effect = ProductEffect.new(:effect => @effect)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render :xml => @effect }
    end
  end

  # GET /effects/new
  # GET /effects/new.xml
  def new
    if params[:product_id]
      @effect.product = Product.find(params[:product_id])
    end
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render :xml => @effect }
    end
  end

  # GET /effects/1/edit
  def edit
  end

  # POST /effects
  # POST /effects.xml
  def create
    respond_to do |format|
      if @effect.save
        format.html { redirect_to([:admin, @effect], :notice => 'Effect was successfully created.') }
        format.xml  { render :xml => @effect, :status => :created, :location => @effect }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @effect.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /effects/1
  # PUT /effects/1.xml
  def update
    respond_to do |format|
      if @effect.update_attributes(params[:effect])
        format.html { redirect_to([:admin, @effect], :notice => 'Effect was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @effect.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /effects/1
  # DELETE /effects/1.xml
  def destroy
    @effect.destroy
    respond_to do |format|
      format.html { redirect_to(admin_effects_url) }
      format.xml  { head :ok }
    end
  end
end
