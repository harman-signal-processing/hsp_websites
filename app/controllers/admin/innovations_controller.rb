class Admin::InnovationsController < AdminController
  before_action :initialize_innovation, only: :create
  load_and_authorize_resource

  # GET /admin/innovations
  # GET /admin/innovations.xml
  def index
    @innovations = @innovations.where(brand_id: website.brand_id).order(:position)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @innovations }
    end
  end

  # GET /admin/innovations/1
  # GET /admin/innovations/1.xml
  def show
    @product_innovation = ProductInnovation.new(innovation: @innovation)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @innovation }
    end
  end

  # GET /admin/innovations/new
  # GET /admin/innovations/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @innovation }
    end
  end

  # GET /admin/innovations/1/edit
  def edit
  end

  # POST /admin/innovations
  # POST /admin/innovations.xml
  def create
    @innovation.brand = website.brand
    respond_to do |format|
      if @innovation.save
        format.html { redirect_to([:admin, @innovation], notice: 'Innovation was successfully created.') }
        format.xml  { render xml: @innovation, status: :created, location: @innovation }
        website.add_log(user: current_user, action: "Created innovation: #{@innovation.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @innovation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/innovations/1
  # PUT /admin/innovations/1.xml
  def update
    respond_to do |format|
      if @innovation.update(innovation_params)
        format.html { redirect_to([:admin, @innovation], notice: 'Innovation was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated innovation: #{@innovation.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @innovation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/innovations/1
  # DELETE /admin/innovations/1.xml
  def destroy
    @innovation.destroy
    respond_to do |format|
      format.html { redirect_to(admin_innovations_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted innovation: #{@innovation.name}")
  end

  private

  def initialize_innovation
    @innovation = Innovation.new(innovation_params)
  end

  def innovation_params
    params.require(:innovation).permit(:name, :short_description, :description, :icon, product_ids: [])
  end
end
