# The ProductAttachment model is really only accessed via the Product. So,
# it doesn't really make sense for its REST controller (this controller)
# to have its own set of views. Instead, the methods in this controller
# should be called via AJAX and return Javascript to update whatever view
# sent the method call.
#
class Admin::ProductAttachmentsController < AdminController
  before_action :initialize_product_attachment, only: :create
  load_and_authorize_resource

  # GET /admin/product_attachments
  # GET /admin/product_attachments.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_attachments }
    end
  end

  # GET /admin/product_attachments/1
  # GET /admin/product_attachments/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_attachment }
    end
  end

  # GET /admin/product_attachments/new
  # GET /admin/product_attachments/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_attachment }
    end
  end

  # GET /admin/product_attachments/1/edit
  def edit
  end

  # POST /admin/product_attachments
  # POST /admin/product_attachments.xml
  def create
    respond_to do |format|
      if @product_attachment.save
        format.html {
          if params[:return_to]
            return_to = URI.parse(params[:return_to]).path
            redirect_to(return_to, notice: "Image was successfully uploaded. It may take a few minutes for the additional sizes to be created.")
          else
            redirect_to([:admin, @product_attachment.product], notice: 'Product Attachment was successfully created.')
          end
        }
        format.xml  { render xml: @product_attachment, status: :created, location: @product_attachment }
        format.js # Not really applicable because the attachment can't be sent via AJAX
        website.add_log(user: current_user, action: "Created product attachment for #{@product_attachment.product.name}")
      else
        format.html { redirect_to([:admin, @product_attachment.product], notice: 'There was a problem creating the Product Attachment.') }
        format.xml  { render xml: @product_attachment.errors, status: :unprocessable_entity }
        format.js { render plain: "Error" }
      end
    end
  end

  # PUT /admin/product_attachments/1
  # PUT /admin/product_attachments/1.xml
  def update
    product = @product_attachment.product
    @old_primary_photo = product.primary_photo
    @called_from = params[:called_from] || "admin_site"
    respond_to do |format|
      if @product_attachment.update(product_attachment_params)
        @old_primary_photo.primary_photo = false
        format.html {
          if params[:return_to]
            return_to = URI.parse(params[:return_to]).path
            redirect_to(return_to, notice: "Image was successfully uploaded. It may take a few minutes for the additional sizes to be created.")
          else
            redirect_to(edit_admin_product_attachment_path(@product_attachment), notice: 'Product Attachment was successfully updated.')
          end
        }
        format.xml  { head :ok }
        format.js
        website.add_log(user: current_user, action: "Updated product attachment for #{@product_attachment.product.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_attachment.errors, status: :unprocessable_entity }
        format.js { render plain: "Error" }
      end
    end
  end

  # POST /admin/product_attachments/update_order
  def update_order
    update_list_order(ProductAttachment, params["product_attachment"])
    head :ok
    website.add_log(user: current_user, action: "Sorted product attachments")
  end

  # DELETE /admin/product_attachments/1
  # DELETE /admin/product_attachments/1.xml
  def destroy
    @called_from = params[:called_from] || "admin_site"
    @product_attachment.destroy
    @primary_photo = false
    if @product_attachment.primary_photo
      product = @product_attachment.product
      @primary_photo = product.photo
    end
    respond_to do |format|
      format.html { redirect_to(admin_product_attachments_url) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted a product attachment from #{@product_attachment.product.name}")
  end

  private

  def initialize_product_attachment
    @product_attachment = ProductAttachment.new(product_attachment_params)
  end

  def product_attachment_params
    params.require(:product_attachment).permit(
      :product_id,
      :primary_photo,
      :product_attachment,
      :position,
      :product_media,
      :product_media,
      :width,
      :height,
      :no_lightbox,
      :hide_from_product_page,
      :product_attachment_meta,
      :full_width_banner_url,
      :show_as_full_width_banner
    )
  end
end
