class Admin::SpecificationGroupsController < AdminController
  before_action :initialize_specification_group, only: :create
  load_and_authorize_resource

  # GET /admin/specification_groups
  # GET /admin/specification_groups.xml
  def index
    respond_to do |format|
      format.html { redirect_to [:admin, :specifications] } # index.html.erb
      format.xml  { render xml: @specification_groups }
    end
  end

  # GET /admin/specification_groups/1
  # GET /admin/specification_groups/1.xml
  def show
    @specification = Specification.new(specification_group: @specification_group)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @specification_group }
    end
  end

  # GET /admin/specification_groups/new
  # GET /admin/specification_groups/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @specification_group }
    end
  end

  # GET /admin/specification_groups/1/edit
  def edit
  end

  # POST /admin/specification_groups
  # POST /admin/specification_groups.xml
  def create
    respond_to do |format|
      if @specification_group.save
        format.html { redirect_to([:admin, @specification_group], notice: 'Specification group was successfully created.') }
        format.xml  { render xml: @specification_group, status: :created, location: @specification_group }
        website.add_log(user: current_user, action: "Created spec group: #{@specification_group.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @specification_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/specification_groups/1
  # PUT /admin/specification_groups/1.xml
  def update
    respond_to do |format|
      sgp = specification_group_params
      if sgp.include?(:specification_ids)
        @specification = Specification.find(sgp.delete(:specification_ids))
        @specification_group.specifications << @specification
      end
      if @specification_group.update_attributes(sgp)
        format.html { redirect_to([:admin, @specification_group], notice: 'Specification group was successfully updated.') }
        format.js
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated spec group: #{@specification_group.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @specification_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_specification
    @specification = Specification.new(specification_params)
    respond_to do |format|
      if @specification.save
        format.js { render action: "update" }
      end
    end
  end

  # POST /admin/specification_groups/update_order
  def update_order
    update_list_order(SpecificationGroup, params["specification_group"])
    head :ok
  end

  # DELETE /admin/specification_groups/1
  # DELETE /admin/specification_groups/1.xml
  def destroy
    @specification_group.destroy
    respond_to do |format|
      format.html { redirect_to(admin_specification_groups_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted spec group: #{@specification_group.name}")
  end

  private

  def initialize_specification_group
    @specification_group = SpecificationGroup.new(specification_group_params)
  end

  def specification_group_params
    params.require(:specification_group).permit!
  end

  def specification_params
    params.require(:specification).permit!
  end

end
