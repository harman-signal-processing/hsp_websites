class Admin::UsRepsController < AdminController
  before_action :initialize_us_rep, only: :create
  load_and_authorize_resource

  # GET /admin/us_reps
  # GET /admin/us_reps.xml
  def index
    @search = UsRep.ransack(params[:q])
    @us_reps = @search.result.distinct.order(:name)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @us_reps }
    end
  end

  # GET /admin/us_reps/1
  # GET /admin/us_reps/1.xml
  def show
    @us_rep_region = UsRepRegion.new(us_rep_id: @us_rep.id, brand_id: website.brand_id)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @us_rep }
    end
  end

  # GET /admin/us_reps/new
  # GET /admin/us_reps/new.xml
  def new
    @us_rep.us_rep_regions.build
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @us_rep }
    end
  end

  # GET /admin/us_reps/1/edit
  def edit
  end

  # POST /admin/us_reps
  # POST /admin/us_reps.xml
  def create
    respond_to do |format|
      if @us_rep.save
        format.html { redirect_to([:admin, @us_rep], notice: 'Rep was successfully created. Be sure to add a region below.') }
        format.xml  { render xml: @us_rep, status: :created, location: @us_rep }
        website.add_log(user: current_user, action: "Created US Rep #{@us_rep.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @us_rep.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/us_reps/1
  # PUT /admin/us_reps/1.xml
  def update
    respond_to do |format|
      if @us_rep.update(us_rep_params)
        format.html { redirect_to([:admin, @us_rep], notice: 'US Rep was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated US Rep #{@us_rep.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @us_rep.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/us_reps/1
  # DELETE /admin/us_reps/1.xml
  def destroy
    @us_rep.destroy
    respond_to do |format|
      format.html { redirect_to(admin_us_reps_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted US Rep #{@us_rep.name}")
  end

  private

  def initialize_us_rep
    @us_rep = UsRep.new(us_rep_params)
  end

  def us_rep_params
    params.require(:us_rep).permit(
      :name,
      :contact,
      :address,
      :city,
      :state,
      :zip,
      :phone,
      :fax,
      :email,
      :contacts,
      us_region_ids: [],
      us_regions_attributes: {}
    )
  end
end
