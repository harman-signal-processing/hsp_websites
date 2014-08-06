class Admin::ProductAudioDemosController < AdminController
  before_filter :initialize_product_audio_demo, only: :create
  load_and_authorize_resource
  
  # GET /admin/product_audio_demos
  # GET /admin/product_audio_demos.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_audio_demos }
    end
  end

  # GET /admin/product_audio_demos/1
  # GET /admin/product_audio_demos/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_audio_demo }
    end
  end

  # GET /admin/product_audio_demos/new
  # GET /admin/product_audio_demos/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_audio_demo }
    end
  end

  # GET /admin/product_audio_demos/1/edit
  def edit
  end

  # POST /admin/product_audio_demos
  # POST /admin/product_audio_demos.xml
  def create
    @called_from = params[:called_from] || "product"
    respond_to do |format|
      if @product_audio_demo.save
        format.html { redirect_to([:admin, @product_audio_demo], notice: 'Product audio demo was successfully created.') }
        format.xml  { render xml: @product_audio_demo, status: :created, location: @product_audio_demo }
        format.js 
        website.add_log(user: current_user, action: "Associated audio demo #{@product_audio_demo.audio_demo.name} with #{@product_audio_demo.product.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product_audio_demo.errors, status: :unprocessable_entity }
        format.js { render template: "admin/product_audio_demos/create_error" }
      end
    end
  end

  # PUT /admin/product_audio_demos/1
  # PUT /admin/product_audio_demos/1.xml
  def update
    respond_to do |format|
      if @product_audio_demo.update_attributes(product_audio_demo_params)
        format.html { redirect_to([:admin, @product_audio_demo], notice: 'Product audio demo was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_audio_demo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/product_audio_demos/1
  # DELETE /admin/product_audio_demos/1.xml
  def destroy
    @product_audio_demo.destroy
    respond_to do |format|
      format.html { redirect_to(admin_product_audio_demos_url) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted audio demo #{@product_audio_demo.audio_demo.name} from #{@product_audio_demo.product.name}")
  end

  private

  def initialize_product_audio_demo
    @product_audio_demo = ProductAudioDemo.new(product_audio_demo_params)
  end

  def product_audio_demo_params
    params.require(:product_audio_demo).permit!
  end
end
