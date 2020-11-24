class Admin::ServiceCentersController < AdminController
  before_action :initialize_service_center, only: :create
  load_and_authorize_resource

  # GET /service_centers
  # GET /service_centers.xml
  def index
    @search = ServiceCenter.ransack(params[:q])
    if params[:q]
      @service_centers = @search.result.order(:name)
    else
      @service_centers = ServiceCenter.where(brand_id: website.brand_id).order(Arel.sql("UPPER(name)"))
    end
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @service_centers }
    end
  end

  # GET /service_centers/1
  # GET /service_centers/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @service_center }
    end
  end

  # GET /service_centers/new
  # GET /service_centers/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @service_center }
    end
  end

  # GET /service_centers/1/edit
  def edit
  end

  # POST /service_centers
  # POST /service_centers.xml
  def create
    @service_center.brand = website.brand
    respond_to do |format|
      if @service_center.save
        format.html { redirect_to([:admin, @service_center], notice: 'Service center was successfully created.') }
        format.xml  { render xml: @service_center, status: :created, location: @service_center }
        website.add_log(user: current_user, action: "Updated a service center: #{@service_center.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @service_center.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /service_centers/1
  # PUT /service_centers/1.xml
  def update
    respond_to do |format|
      if @service_center.update(service_center_params)
        format.html { redirect_to([:admin, @service_center], notice: 'Service center was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated a service center: #{@service_center.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @service_center.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service_centers/1
  # DELETE /service_centers/1.xml
  def destroy
    @service_center.destroy
    respond_to do |format|
      format.html { redirect_to(admin_service_centers_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted service center: #{@service_center.name}")
  end

  private

  def initialize_service_center
    @service_center = ServiceCenter.new(service_center_params)
  end

  def service_center_params
    params.require(:service_center).permit(
      :name,
      :name2,
      :name3,
      :name4,
      :address,
      :city,
      :state,
      :zip,
      :telephone,
      :fax,
      :email,
      :account_number,
      :website,
      :lat,
      :lng,
      :brand_id,
      :vintage
    )
  end
end
