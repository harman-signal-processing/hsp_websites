class Admin::CabinetsController < AdminController
  before_filter :initialize_cabinet, only: :create
  load_and_authorize_resource
  
  # GET /cabinets
  # GET /cabinets.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @cabinets }
    end
  end

  # GET /cabinets/1
  # GET /cabinets/1.xml
  def show
    @product_cabinet = ProductCabinet.new(cabinet: @cabinet)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @cabinet }
    end
  end

  # GET /cabinets/new
  # GET /cabinets/new.xml
  def new
    if params[:product_id]
      @cabinet.product = Product.find(params[:product_id])
    end
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @cabinet }
    end
  end

  # GET /cabinets/1/edit
  def edit
  end

  # POST /cabinets
  # POST /cabinets.xml
  def create
    respond_to do |format|
      if @cabinet.save
        format.html { redirect_to([:admin, @cabinet], notice: 'Cabinet was successfully created.') }
        format.xml  { render xml: @cabinet, status: :created, location: @cabinet }
        website.add_log(user: current_user, action: "Created cabinet: #{@cabinet.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @cabinet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cabinets/1
  # PUT /cabinets/1.xml
  def update
    respond_to do |format|
      if @cabinet.update_attributes(cabinet_params)
        format.html { redirect_to([:admin, @cabinet], notice: 'Cabinet was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated cabinet: #{@cabinet.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @cabinet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cabinets/1
  # DELETE /cabinets/1.xml
  def destroy
    @cabinet.destroy
    respond_to do |format|
      format.html { redirect_to(admin_cabinets_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted cabinet: #{@cabinet.name}")
  end

  private

  def initialize_cabinet
    @cabinet = Cabinet.new(cabinet_params)
  end

  def cabinet_params
    params.require(:cabinet).permit!
  end
end
