class Admin::SiteElementAttachmentsController < AdminController
  before_action :load_site_element
  before_action :initialize_site_element_attachment, only: :create
  load_and_authorize_resource

  # GET /admin/site_element_attachments
  # GET /admin/site_element_attachments.xml
  def index
    @site_element_attachment = @site_element.site_element_attachments
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @site_element_attachments }
    end
  end

  # GET /admin/site_element_attachments/1
  # GET /admin/site_element_attachments/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @site_element_attachment }
    end
  end

  # GET /admin/site_element_attachments/new
  # GET /admin/site_element_attachments/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @site_element_attachment }
    end
  end

  # GET /admin/site_element_attachments/1/edit
  def edit
  end

  # POST /admin/site_element_attachments
  # POST /admin/site_element_attachments.xml
  def create
    respond_to do |format|
      if @site_element_attachment.save
        format.html { redirect_to([:admin, @site_element], notice: 'Attachment was successfully created.') }
        format.xml  { render xml: @site_element_attachment, status: :created, location: @site_element_attachment }
        format.js # Not really applicable because the attachment can't be sent via AJAX
      else
        format.html { redirect_to([:admin, @site_element], alert: 'There was a problem creating the Attachment.') }
        format.xml  { render xml: @site_element_attachment.errors, status: :unprocessable_entity }
        format.js { render plain: "Error" }
      end
    end
  end

  # PUT /admin/site_element_attachments/1
  # PUT /admin/site_element_attachments/1.xml
  def update
    respond_to do |format|
      if @site_element_attachment.update(site_element_attachment_params)
        format.html { redirect_to([:admin, @site_element], notice: 'Attachment was successfully updated.') }
        format.xml  { head :ok }
        format.js
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @site_element_attachment.errors, status: :unprocessable_entity }
        format.js { render plain: "Error" }
      end
    end
  end

  # DELETE /admin/site_element_attachments/1
  # DELETE /admin/site_element_attachments/1.xml
  def destroy
    @site_element_attachment.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @site_element]) }
      format.xml  { head :ok }
      format.js
    end
  end

  private

  def load_site_element
    @site_element = SiteElement.find(params[:site_element_id])
  end

  def initialize_site_element_attachment
    @site_element_attachment = SiteElementAttachment.new(site_element_attachment_params)
  end

  def site_element_attachment_params
    params.require(:site_element_attachment).permit!
  end
end

