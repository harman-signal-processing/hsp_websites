class Admin::ProductDocumentsController < AdminController
  before_action :initialize_product_document, only: :create
  load_and_authorize_resource

  # GET /admin/product_documents
  # GET /admin/product_documents.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_documents }
    end
  end

  # GET /admin/product_documents/1
  # GET /admin/product_documents/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_document }
    end
  end

  # GET /admin/product_documents/new
  # GET /admin/product_documents/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_document }
    end
  end

  # GET /admin/product_documents/1/edit
  def edit
  end

  # POST /admin/site_elements/upload
  # Callback after uploading a file directly to S3. Adds the temporary S3 path
  # to the form before creating new software.
  def upload
    @direct_upload_url = params[:direct_upload_url]
    respond_to do |format|
      format.js
    end
  end

  # POST /admin/product_documents
  # POST /admin/product_documents.xml
  def create
    respond_to do |format|
      if @product_document.save
        format.html { redirect_to([:admin, @product_document.product], notice: 'Product Document was successfully created.') }
        format.xml  { render xml: @product_document, status: :created, location: @product_document }
        website.add_log(user: current_user, action: "Added document to #{@product_document.product.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/product_documents/1
  # PUT /admin/product_documents/1.xml
  def update
    respond_to do |format|
      if @product_document.update(product_document_params)
        format.html { redirect_to([:admin, @product_document], notice: 'Product Document was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated product document for #{@product_document.product.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /admin/product_documents/update_order
  def update_order
    update_list_order(ProductDocument, params["product_document"])
    head :ok
    website.add_log(user: current_user, action: "Sorted product documents")
  end

  # DELETE /admin/product_documents/1
  # DELETE /admin/product_documents/1.xml
  def destroy
    @product_document.destroy
    respond_to do |format|
      format.html { redirect_to(admin_product_documents_url) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Removed product document from #{@product_document.product.name}")
  end

  private

  def initialize_product_document
    @product_document = ProductDocument.new(product_document_params)
  end

  def product_document_params
    params.require(:product_document).permit(
      :product_id,
      :language,
      :document_type,
      :document,
      :name_override,
      :position,
      :direct_upload_url,
      :show_on_public_site
    )
  end
end
