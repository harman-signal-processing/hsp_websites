class Admin::ContactMessagesController < AdminController
  load_and_authorize_resource

  # GET /admin/contact_messages
  # GET /admin/contact_messages.xml
  def index
    # @contact_messages = @contact_messages.where(brand_id: website.brand_id).order("post_on DESC")
    @search = website.brand.contact_messages.ransack(params[:q])
    @contact_messages = @search.result.paginate(page: params[:page], per_page: 50)
    @search_attempted = false
    if params[:q]
      @search_attempted = true
    else
      @contact_messages = website.brand.contact_messages.order("created_at DESC").paginate(page: params[:page], per_page: 50)
    end
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @contact_messages }
    end
  end

  # GET /admin/contact_message/1
  # GET /admin/contact_message/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @contact_message }
    end
  end

  # DELETE /admin/contact_message/1
  # DELETE /admin/contact_message/1.xml
  def destroy
    @contact_message.destroy
    respond_to do |format|
      format.html { redirect_to(admin_contact_messages_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted contact message: #{@contact_message.id}")
  end

end
