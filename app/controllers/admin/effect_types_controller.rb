class Admin::EffectTypesController < AdminController
  before_action :initialize_effect_type, only: :create
  load_and_authorize_resource
  
  # GET /effect_types
  # GET /effect_types.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @effect_types }
    end
  end

  # GET /effect_types/1
  # GET /effect_types/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @effect_type }
    end
  end

  # GET /effect_types/new
  # GET /effect_types/new.xml
  def new
    if params[:product_id]
      @effect_type.product = Product.find(params[:product_id])
    end
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @effect_type }
    end
  end

  # GET /effect_types/1/edit
  def edit
  end

  # POST /effect_types
  # POST /effect_types.xml
  def create
    respond_to do |format|
      if @effect_type.save
        format.html { redirect_to([:admin, @effect_type], notice: 'EffectType was successfully created.') }
        format.xml  { render xml: @effect_type, status: :created, location: @effect_type }
        format.js
        website.add_log(user: current_user, action: "Created effect type: #{@effect_type.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @effect_type.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT /admin/effect_types/update_order
  def update_order
    update_list_order(EffectType, params["effect_type"])
    head :ok
    website.add_log(user: current_user, action: "Re-ordered effect types")
  end

  # PUT /effect_types/1
  # PUT /effect_types/1.xml
  def update
    respond_to do |format|
      if @effect_type.update(effect_type_params)
        format.html { redirect_to([:admin, @effect_type], notice: 'EffectType was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated effect type: #{@effect_type.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @effect_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /effect_types/1
  # DELETE /effect_types/1.xml
  def destroy
    @effect_type.destroy
    respond_to do |format|
      format.html { redirect_to(admin_effect_types_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted effect type: #{@effect_type.name}")
  end

  private

  def initialize_effect_type
    @effect_type = EffectType.new(effect_type_params)
  end

  def effect_type_params
    params.require(:effect_type).permit!
  end
end
