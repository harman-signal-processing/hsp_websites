class Admin::SoftwareAttachmentsController < AdminController
  before_action :initialize_software_attachment, only: :create
  load_and_authorize_resource

  # GET /admin/software_attachments
  # GET /admin/software_attachments.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @software_attachments }
    end
  end

  # GET /admin/software_attachments/1
  # GET /admin/software_attachments/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @software_attachment }
    end
  end

  # GET /admin/software_attachments/new
  # GET /admin/software_attachments/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @software_attachment }
    end
  end

  # GET /admin/software_attachments/1/edit
  def edit
  end

  # POST /admin/software_attachments
  # POST /admin/software_attachments.xml
  def create
    respond_to do |format|
      if @software_attachment.save
        format.html { redirect_to([:admin, @software_attachment.software], notice: 'Software attachment was successfully created.') }
        format.xml  { render xml: @software_attachment, status: :created, location: @software_attachment }
      else
        format.html { render plain: "Sorry, there was a problem with the upload. Please go back and try again." }
        format.xml  { render xml: @software_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/software_attachments/1
  # PUT /admin/software_attachments/1.xml
  def update
    respond_to do |format|
      if @software_attachment.update(software_attachment_params)
        format.html { redirect_to([:admin, @software_attachment], notice: 'Software attachment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @software_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/software_attachments/1
  # DELETE /admin/software_attachments/1.xml
  def destroy
    @software_attachment.destroy
    respond_to do |format|
      format.html { redirect_to(admin_software_attachments_url) }
      format.xml  { head :ok }
      format.js
    end
  end

  private

  def initialize_software_attachment
    @software_attachment = SoftwareAttachment.new(software_attachment_params)
  end

  def software_attachment_params
    params.require(:software_attachment).permit(
      :name,
      :software_id,
      :software_attachment
    )
  end
end
