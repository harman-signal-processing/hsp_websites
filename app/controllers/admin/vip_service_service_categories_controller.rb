class Admin::VipServiceServiceCategoriesController < AdminController
	before_action :initialize_vip_service_service_category, only: :create
  load_and_authorize_resource class: "Vip::ServiceServiceCategory"	
  
  
  # GET /admin/vip_service_service_categories
  # GET /admin/vip_service_service_categories.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @vip_service_service_category }
    end
  end  
  
  # GET /admin/vip_service_service_categories/1
  # GET /admin/vip_service_service_categories/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @vip_service_service_category }
    end
  end  
  
  # GET /admin/vip_service_service_categories/new
  # GET /admin/vip_service_service_categories/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @vip_service_service_category }
    end
  end

  # GET /admin/vip_service_service_categories/1/edit
  def edit
  end   
  
  # POST /admin/vip_service_service_categories
  # POST /admin/vip_service_service_categories.xml
  def create
    @called_from = params[:called_from] || "vip_service"
    respond_to do |format|
      if @vip_service_service_categories.present?
        begin
          @vip_service_service_categories.each do |vip_service_service_category|
            begin
              vip_service_service_category.save!
              website.add_log(user: current_user, action: "Associated #{vip_service_service_category.service.name} with #{vip_service_service_category.service_category.name}")
              format.js
            rescue => e
              @error = "Error: #{e.message} : #{vip_service_service_category.service_category.name}"
              format.js { render template: "admin/vip_service_service_categories/create_error" }
            end
          end  #  @vip_service_service_categories.each do |vip_service_service_category|
          
        rescue => e
          @error = "Error: #{e.message}"
          format.js { render template: "admin/vip_service_service_categories/create_error" }
        end        
      else       
        if @vip_service_service_category.save
          format.html { redirect_to([:admin, @vip_service_service_category], notice: 'Service service category was successfully created.') }
          format.xml  { render xml: @vip_service_service_category, status: :created, location: @vip_service_service_category }
          format.js 
          website.add_log(user: current_user, action: "Associated #{vip_service_service_category.service.name} with #{vip_service_service_category.service_category.name}")
        else
          format.html { render action: "new" }
          format.xml  { render xml: @vip_service_service_category.errors, status: :unprocessable_entity }
          format.js { render template: "admin/vip_service_service_categories/create_error" }
        end
      end
    end  #  respond_to do |format|
  end  #  def create   
  
  # PUT /admin/vip_service_service_categories/1
  # PUT /admin/vip_service_service_categories/1.xml
  def update
    respond_to do |format|
      if @vip_service_service_category.update_attributes(vip_service_service_category_params)
        format.html { redirect_to([:admin, @vip_service_service_category], notice: 'Service service category was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_service_service_category.errors, status: :unprocessable_entity }
      end
    end
  end   
  
  # DELETE /admin/vip_service_service_categories/1
  # DELETE /admin/vip_service_service_categories/1.xml
  def destroy
    @called_from = params[:called_from] || "vip_service"
    @vip_service_service_category.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_service_service_categories_url) }
      format.xml  { head :ok }
      format.js 
    end
    website.add_log(user: current_user, action: "Removed a service category from #{@vip_service_service_category.service.name}")
  end    
  
  private

	def initialize_vip_service_service_category
    if vip_service_service_category_params[:vip_service_category_id].is_a?(Array)
      @vip_service_service_categories = []
      vip_service_id = vip_service_service_category_params[:vip_service_id]
      vip_service_service_category_params[:vip_service_category_id].reject(&:blank?).each do |category|
        @vip_service_service_categories << Vip::ServiceServiceCategory.new({vip_service_id: vip_service_id, vip_service_category_id: category})
      end        
    else
      @vip_service_service_category = Vip::ServiceServiceCategory.new(vip_service_service_category_params)
    end	 	    
  end  #  def initialize_vip_service_service_category
	
	  def vip_service_service_category_params
	    params.require(:vip_service_service_category).permit!
	  end  
end
