class Admin::DistributorsController < AdminController
  before_filter :initialize_distributor, only: :create
  load_and_authorize_resource

  # GET /admin/distributors
  # GET /admin/distributors.xml
  def index
    @this_brand = !!(params[:this_brand].to_i > 0)
    @search = (@this_brand) ? website.brand.distributors.ransack(params[:q]) : Distributor.ransack(params[:q])
    @distributors = @search.result.order(:name)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @distributors }
    end
  end

  # GET /admin/distributors/1
  # GET /admin/distributors/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @distributor }
    end
  end

  # GET /admin/distributors/new
  # GET /admin/distributors/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @distributor }
    end
  end

  # GET /admin/distributors/1/edit
  def edit
  end

  # POST /admin/distributors
  # POST /admin/distributors.xml
  def create
    respond_to do |format|
      if @distributor.save
        @distributor.create_brand_distributor(website)
        format.html { redirect_to([:admin, @distributor], notice: 'Distributor was successfully created.') }
        format.xml  { render xml: @distributor, status: :created, location: @distributor }
        website.add_log(user: current_user, action: "Created distributor #{@distributor.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @distributor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/distributors/1
  # PUT /admin/distributors/1.xml
  def update
    respond_to do |format|
      if @distributor.update_attributes(distributor_params)
        format.html { redirect_to([:admin, @distributor], notice: 'Distributor was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated distributor #{@distributor.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @distributor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/distributors/1
  # DELETE /admin/distributors/1.xml
  def destroy
    if @distributor.brand_distributors.size <= 1
      @distributor.destroy
    else
      @distributor.brand_distributors.each do |db|
        db.destroy if db.brand == website.brand
      end
    end
    respond_to do |format|
      format.html { redirect_to(admin_distributors_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted distributor #{@distributor.name}")
  end

  private

  def initialize_distributor
    @distributor = Distributor.new(distributor_params)
  end

  def distributor_params
    params.require(:distributor).permit!
  end
end
