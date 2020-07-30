class Admin::VipServiceCategoriesController < AdminController
  load_and_authorize_resource class: "Vip::ServiceCategory"

  def index
    @vip_service_categories = Vip::ServiceCategory.all.order(:name)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @vip_service_categories }
      format.json  { render json: @vip_service_categories }
    end    
  end

  def show
  end

  def new
  end

  def edit
  end
  
  def update
    @vip_service_category = Vip::ServiceCategory.find(params[:id])
    respond_to do |format|
      if @vip_service_category.update(vip_service_category_params)
        format.html { redirect_to(admin_vip_service_categories_path, notice: 'AMX VIP ServiceCategory was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated a amx vip service_category: #{@vip_service_category.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_service_category.errors, status: :unprocessable_entity }
      end
    end 
  end  
  
  def create
    @vip_service_category = Vip::ServiceCategory.new(vip_service_category_params)
    respond_to do |format|
      if @vip_service_category.save

        format.html { redirect_to(admin_vip_service_categories_path, notice: 'AMX VIP ServiceCategory was successfully created.') }
        format.xml  { render xml: @vip_service_category, status: :created, location: @vip_service_category }
        format.js # Not really applicable because the attachment can't be sent via AJAX
        website.add_log(user: current_user, action: "Created amx vip service_category #{@vip_service_category.name}")
      else
        format.html { redirect_to(admin_vip_service_categories_path, notice: 'There was a problem creating the AMX VIP ServiceCategory.') }
        format.xml  { render xml: @vip_service_category.errors, status: :unprocessable_entity }
        format.js { render plain: "Error" }
      end
    end      
  end    
  
  # DELETE /vip_service_categories/1
  # DELETE /vip_service_categories/1.xml
  def destroy
    @vip_service_category.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_service_categories_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted a amx vip service_category: #{@vip_service_category.name}")
  end   
  
  private
  
    def vip_service_category_params
  	  params.require(:vip_service_category).permit!
    end     

end
