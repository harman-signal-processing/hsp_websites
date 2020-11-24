class Admin::AudioDemosController < AdminController
  before_action :initialize_audio_demo, only: :create
  load_and_authorize_resource

  # GET /audio_demos
  # GET /audio_demos.xml
  def index
    @audio_demos = @audio_demos.where(brand_id: website.brand_id)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @audio_demos }
    end
  end

  # GET /audio_demos/1
  # GET /audio_demos/1.xml
  def show
    @product_audio_demo = ProductAudioDemo.new(audio_demo: @audio_demo)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @audio_demo }
    end
  end

  # GET /audio_demos/new
  # GET /audio_demos/new.xml
  def new
    if params[:product_id]
      @audio_demo.product = Product.find(params[:product_id])
    end
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @audio_demo }
    end
  end

  # GET /audio_demos/1/edit
  def edit
  end

  # POST /audio_demos
  # POST /audio_demos.xml
  def create
    respond_to do |format|
      @audio_demo.brand_id = website.brand_id
      if @audio_demo.save
        format.html { redirect_to([:admin, @audio_demo], notice: 'Audio Demo was successfully created.') }
        format.xml  { render xml: @audio_demo, status: :created, location: @audio_demo }
        website.add_log(user: current_user, action: "Created an audio demo named #{@audio_demo.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @audio_demo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /audio_demos/1
  # PUT /audio_demos/1.xml
  def update
    respond_to do |format|
      if @audio_demo.update(audio_demo_params)
        format.html { redirect_to([:admin, @audio_demo], notice: 'Audio Demo was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated audio demo #{@audio_demo.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @audio_demo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /audio_demos/1
  # DELETE /audio_demos/1.xml
  def destroy
    @audio_demo.destroy
    respond_to do |format|
      format.html { redirect_to(admin_audio_demos_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted audio demo #{@audio_demo.name}")
  end

  private

  def initialize_audio_demo
    @audio_demo = AudioDemo.new(audio_demo_params)
  end

  def audio_demo_params
    params.require(:audio_demo).permit(:name, :description, :wet_demo, :dry_demo, :duration_in_seconds)
  end
end
