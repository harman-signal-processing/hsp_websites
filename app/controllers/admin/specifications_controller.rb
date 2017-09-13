class Admin::SpecificationsController < AdminController
  before_action :initialize_specification, only: :create
  load_and_authorize_resource

  # GET /admin/specifications
  # GET /admin/specifications.xml
  def index
    @specification_groups = SpecificationGroup.order("position", "name")
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @specifications }
    end
  end

  # GET /admin/specifications/1
  # GET /admin/specifications/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @specification }
    end
  end

  # GET /admin/specifications/new
  # GET /admin/specifications/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @specification }
    end
  end

  # GET /admin/specifications/1/edit
  def edit
  end

  # POST /admin/specifications
  # POST /admin/specifications.xml
  def create
    respond_to do |format|
      if @specification.save
        format.html { redirect_to([:admin, @specification], notice: 'Specification was successfully created.') }
        format.xml  { render xml: @specification, status: :created, location: @specification }
        website.add_log(user: current_user, action: "Created spec: #{@specification.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @specification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/specifications/1
  # PUT /admin/specifications/1.xml
  def update
    respond_to do |format|
      if @specification.update_attributes(specification_params)
        format.html { redirect_to([:admin, @specification], notice: 'Specification was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated spec: #{@specification.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @specification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/specifications/1
  # DELETE /admin/specifications/1.xml
  def destroy
    @specification.destroy
    respond_to do |format|
      format.html { redirect_to(admin_specifications_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted spec: #{@specification.name}")
  end  

  private

  def initialize_specification
    @specification = Specification.new(specification_params)
  end

  def specification_params
    params.require(:specification).permit!
  end


end
