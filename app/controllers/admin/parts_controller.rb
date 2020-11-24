class Admin::PartsController < AdminController
  before_action :initialize_part, only: :create
  load_and_authorize_resource

  # GET /parts
  # GET /parts.xml
  def index
    @parts = @parts.order(:part_number)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @parts }
    end
  end

  # GET /parts/1
  # GET /parts/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @part }
    end
  end

  # GET /parts/new
  # GET /parts/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @part }
    end
  end

  # GET /parts/1/edit
  def edit
  end

  # POST /parts
  # POST /parts.xml
  def create
    respond_to do |format|
      if @part.save
        format.html { redirect_to([:admin, @part], notice: 'Part was successfully created.') }
        format.xml  { render xml: @part, status: :created, location: @part }
        website.add_log(user: current_user, action: "Created part: #{@part.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /parts/1
  # PUT /parts/1.xml
  def update
    respond_to do |format|
      if @part.update(part_params)
        format.html { redirect_to([:admin, @part], notice: 'Part was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated part: #{@part.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parts/1
  # DELETE /parts/1.xml
  def destroy
    @part.destroy
    respond_to do |format|
      format.html { redirect_to(admin_parts_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted part: #{@part.name}")
  end

  private

  def initialize_part
    @part = Part.new(part_params)
  end

  def part_params
    params.require(:part).permit(
      :part_number,
      :description,
      :photo,
      :parent_id
    )
  end
end

