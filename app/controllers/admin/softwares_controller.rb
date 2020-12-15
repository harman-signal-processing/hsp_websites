class Admin::SoftwaresController < AdminController
  before_action :initialize_software, only: :create
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
    @locale_software = LocaleSoftware.new(software: @software)
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

  def new_version
    @old_software = @software
    @software = Software.new(replaces_id: @old_software.to_param, active: true)
  end

  # GET /admin/softwares/1/edit
  def edit
  end

  # POST /admin/softwares/upload
  # Callback after uploading a file directly to S3. Adds the temporary S3 path
  # to the form before creating new software.
  def upload
    @direct_upload_url = params[:direct_upload_url]
    respond_to do |format|
      format.js
    end
  end

  # POST /admin/softwares
  # POST /admin/softwares.xml
  def create
    @software.brand = website.brand
    respond_to do |format|
      if @software.save
        format.html {
          if params[:return_to]
            return_to = (params[:return_to] == "public_path") ? software_path(@software, locale: I18n.locale) : URI.parse(params[:return_to]).path
            redirect_to(return_to, notice: "Software was successfully uploaded.")
          else
            redirect_to([:admin, @software], notice: 'Software was successfully created. Wait a few minutes while the system copies the software to our content delivery network.')
          end
        }
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
      if @software.update(software_params)
        format.html {
          if params[:return_to]
            return_to = URI.parse(params[:return_to]).path
            redirect_to(return_to, notice: "Software was successfully updated.")
          else
            redirect_to([:admin, @software], notice: 'Software was successfully updated. If you replaced the file, please wait while the system propagates the changes to our content delivery network.')
          end
        }
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
      format.html {
        if params[:return_to]
          return_to = URI.parse(params[:return_to]).path
          redirect_to(return_to, notice: "#{@software.formatted_name} was successfully deleted.")
        else
          redirect_to(admin_softwares_url)
        end
      }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted software: #{@software.name}")
  end

  private

  def initialize_software
    @software = Software.new(software_params)
  end

  def software_params
    params.require(:software).permit(
      :name,
      :ware,
      :download_count,
      :version,
      :description,
      :platform,
      :active,
      :category,
      :brand_id,
      :link,
      :multipliers,
      :activation_name,
      :layout_class,
      :current_version_id,
      :bit,
      :active_without_products,
      :direct_upload_url,
      :alert,
      :show_alert,
      :side_content,
      :replaces_id,
      product_id: [],
      product_ids: []
    )
  end
end
