class Admin::ProductEffectsController < AdminController
  load_and_authorize_resource
  # GET /admin/product_effects
  # GET /admin/product_effects.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_effects }
    end
  end

  # GET /admin/product_effects/1
  # GET /admin/product_effects/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_effect }
    end
  end

  # GET /admin/product_effects/new
  # GET /admin/product_effects/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_effect }
    end
  end

  # GET /admin/product_effects/1/edit
  def edit
  end

  # POST /admin/product_effects
  # POST /admin/product_effects.xml
  def create
    begin
      effect = Effect.new(params[:effect])
      if effect.save
        @product_effect.effect = effect
      end
    rescue
      # probably didn't have a form that can provide a new Effect
    end
    @called_from = params[:called_from] || "product"
    respond_to do |format|
      if @product_effect.save
        format.html { redirect_to([:admin, @product_effect], notice: 'Product effect was successfully created.') }
        format.xml  { render xml: @product_effect, status: :created, location: @product_effect }
        format.js 
        website.add_log(user: current_user, action: "Added effect #{@product_effect.effect.name} to #{@product_effect.product.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product_effect.errors, status: :unprocessable_entity }
        format.js { render template: "create_error" }
      end
    end
  end

  # PUT /admin/product_effects/1
  # PUT /admin/product_effects/1.xml
  def update
    respond_to do |format|
      if @product_effect.update_attributes(params[:product_effect])
        format.html { redirect_to([:admin, @product_effect], notice: 'Product effect was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_effect.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/product_effects/1
  # DELETE /admin/product_effects/1.xml
  def destroy
    @product_effect.destroy
    respond_to do |format|
      format.html { redirect_to(admin_product_effects_url) }
      format.xml  { head :ok }
      format.js 
    end
    website.add_log(user: current_user, action: "Removed effect #{@product_effect.effect.name} from #{@product_effect.product.name}")
  end
end
