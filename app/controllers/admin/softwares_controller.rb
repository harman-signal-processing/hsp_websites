class Admin::SoftwaresController < AdminController
  load_and_authorize_resource
  
  # GET /admin/softwares
  # GET /admin/softwares.xml
  def index
    @softwares = @softwares.where(brand_id: website.brand_id).where("current_version_id IS NULL or current_version_id = 0").order("name, version")
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @softwares }
    end
  end

  # GET /admin/softwares/1
  # GET /admin/softwares/1.xml
  def show
    @product_software = ProductSoftware.new(software: @software)
    @software_attachment = SoftwareAttachment.new(software: @software)
    @software_training_module = SoftwareTrainingModule.new(software: @software)
    @software_training_class = SoftwareTrainingClass.new(software: @software)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @software }
    end
  end

  # GET /admin/softwares/new
  # GET /admin/softwares/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @software }
    end
  end

  # GET /admin/softwares/1/edit
  def edit
  end

  # POST /admin/softwares
  # POST /admin/softwares.xml
  def create
    @software.brand = website.brand
    respond_to do |format|
      if @software.save
        format.html { redirect_to([:admin, @software], notice: 'Software was successfully created. Wait a few minutes while the system copies the software to our content delivery network.') }
        format.xml  { render xml: @software, status: :created, location: @software }
        website.add_log(user: current_user, action: "Created software: #{@software.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @software.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/softwares/1
  # PUT /admin/softwares/1.xml
  def update
    respond_to do |format|
      if @software.update_attributes(params[:software])
        format.html { redirect_to([:admin, @software], notice: 'Software was successfully updated. If you replaced the file, please wait while the system propagates the changes to our content delivery network.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated software: #{@software.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @software.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/softwares/1
  # DELETE /admin/softwares/1.xml
  def destroy
    @software.destroy
    respond_to do |format|
      format.html { redirect_to(admin_softwares_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted software: #{@software.name}")
  end
end
